{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.desktop.steamos;
  start-session = pkgs.writeScript "start-session" ''
    #! /usr/bin/env -S ${lib.getExe pkgs.nushell} --plugins ${lib.getExe pkgs.nushell-plugin-formats} --no-config-file

    # [Autologin]\nSession={session}\n
    const TEMP_CONFIG = "/etc/sddm.conf.d/zzt-steamos-temp-login.conf"

    if ($TEMP_CONFIG | path exists) {
      let config = open $TEMP_CONFIG | from ini
      let session = $config.Autologin.Session

      if ($session | str contains "gamescope") {
        exec ${start-gamescope-session}/bin/start-gamescope-session
      } else {
        let desktop = open $session | from ini
        exec $desktop."Desktop Entry".Exec
      }
    } else {
      exec ${start-gamescope-session}/bin/start-gamescope-session
    }
  '';

  start-gamescope-session = pkgs.writeShellScriptBin "start-gamescope-session" ''
    # It is possible to get things remaining from the previous session
    # and our units are still running in the user systemd
    systemctl --user stop gamescope-session.target
    systemctl --user stop graphical-session-pre.target
    systemctl --user reset-failed

    # TODO relevant?
    # This makes it so that xdg-desktop-portal only looks for holo- and
    # gamescope-specific portal implementations and doesn't try to start other
    # irrelevant portal implementations (gtk, kde, …).
    # XDG_DESKTOP_PORTAL_DIR="/usr/share/xdg-desktop-portal/gamescope-portals"

    # Remove these as they prevent gamescope-session from starting correctly
    systemctl --user unset-environment DISPLAY

    # If this shell script is killed then stop gamescope-session
    trap 'systemctl --user stop gamescope-session.target' HUP INT TERM

    # Start gamescope-session target
    systemctl --user --wait start gamescope-session.target

    # The 'wait' above blocks until gamescope-session.target stops
    # We want to wait until *everything* has finished. We know systemd will have
    # queued a stop job on graphical-session-pre aleady
    # by also queuing up a job we can block until that completes
    systemctl --user stop graphical-session-pre.target
  '';

  gamescope-wayland =
    (pkgs.makeDesktopItem {
      name = "gamescope-session";
      desktopName = "Gamescope Wayland Session";
      comment = "A wayland desktop session for running Steam in gamescope";
      exec = "${start-gamescope-session}/bin/start-gamescope-session";
      type = "Application";
      destination = "/share/wayland-sessions";
    }).overrideAttrs
      (_: {
        passthru.providedSessions = [ "gamescope-session" ];
      });
in
{
  options.mordrag.desktop.steamos = {
    enable = lib.mkEnableOption "Steam OS";
  };

  config = lib.mkIf cfg.enable {
    mordrag = {
      desktop.cosmic.enable = true;
      users.main.extraGroups = [ "seat" ];
    };

    networking.networkmanager.wifi.backend = "iwd";

    hardware = {
      steam-hardware.enable = true;
      graphics.extraPackages = [ pkgs.gamescope-wsi ];
    };

    environment = {
      systemPackages = with pkgs; [
        steamos-manager
      ];

      # DMI stuff needs to match
      etc."steamos-manager/config.toml".source = ./config.toml;

      # steamos-manager determines on the existence of this file if the desktop sessions are managed.
      etc."sddm.conf.d/steamos.conf".text = "";

      # Steamos Manager needs this file and doesn't create it on startup
      # https://gitlab.steamos.cloud/holo/steamos-manager/-/blob/main/steamos-manager/src/wifi.rs
      etc."NetworkManager/conf.d/99-valve-wifi-backend.conf" = {
        text = ''
          [connection]
          wifi.powersave=0
          [device]
          wifi.backend=${config.networking.networkmanager.wifi.backend}
        '';

        mode = "0644";
      };
    };

    security.wrappers = {
      gamescope = {
        owner = "root";
        group = "root";
        source = "${pkgs.gamescope}/bin/gamescope";
        capabilities = "cap_sys_nice+pie";
      };
    };

    systemd = {
      packages = with pkgs; [
        steamos-manager
        xdg-desktop-portal-gamescope
      ];

      user = {
        targets.gamescope-session = {
          requires = [
            "graphical-session.target"
            config.systemd.user.services.gamescope-session.name
          ];
          bindsTo = [
            "graphical-session.target"
            config.systemd.user.services.gamescope-session.name
          ];
          after = [ "graphical-session.target" ];
          unitConfig.PropagatesStopTo = [ "graphical-session.target" ];
          upholds = [ config.systemd.user.services.steam-launcher.name ];
        };

        services = {
          gamescope-session = {
            before = [
              "graphical-session.target"
              # The XDG desktop portal frontend relies on the value of $XDG_CURRENT_DESKTOP to
              # decide which backends to load, so its startup should be delayed until after
              # the session is running.
              "xdg-desktop-portal.service"
            ];
            partOf = [ "graphical-session.target" ];
            wants = [ "graphical-session-pre.target" ];
            after = [ "graphical-session-pre.target" ];

            environment = {
              # Session variables
              XDG_SESSION_TYPE = "x11";
              XDG_SESSION_DESKTOP = "gamescope-session";
              XDG_CURRENT_DESKTOP = "gamescope-session";
            };

            path = [ pkgs.mangohud ];

            script = ''
              # Setup socket for gamescope
              # Create run directory file for startup and stats sockets
              tmpdir="$(mktemp -p "$XDG_RUNTIME_DIR" -d -t gamescope.XXXXXXX)"
              socket="$tmpdir/startup.socket"
              stats="$tmpdir/stats.pipe"
              mkfifo -- "$stats"
              mkfifo -- "$socket"

              export GAMESCOPE_STATS="$stats"

              # TODO: need to also import the following two to systemctl ?

              # Enable the gamescope WSI extension to allow gamescope to manage buffers directly
              export ENABLE_GAMESCOPE_WSI=1
              # Don't wait for buffers to idle on the client side before sending them to gamescope
              export vk_xwayland_wait_ready=false

              read_gamescope_env() {
                 	if read -r -t 8 response_x_display response_wl_display <> "$socket"; then
                		export DISPLAY="$response_x_display"
                		export GAMESCOPE_WAYLAND_DISPLAY="$response_wl_display"

                		# Sync environment variables to systemd, then notify we are ready to launch subsequent services
                    systemctl --user import-environment \
                      DISPLAY GAMESCOPE_WAYLAND_DISPLAY \
                      XDG_SESSION_TYPE XDG_SESSION_DESKTOP XDG_CURRENT_DESKTOP

                		systemd-notify --ready
                 	fi
              }

              # Spawned in parallel to read values from gamescope
              (read_gamescope_env &)


              exec /run/wrappers/bin/gamescope \
                  --backend drm \
                  --ready-fd "$socket" \
                  --stats-path "$stats" \
                  --output-width 1920 \
                  --output-height 1080 \
                  --filter fsr \
                  --steam \
                  --mangoapp \
                  --xwayland-count 2
            '';

            serviceConfig = {
              Type = "notify";
              NotifyAccess = "all";
              TimeoutStartSec = 5;
              TimeoutStopSec = 10;
            };
          };

          steam-launcher = {
            description = "Steam Launcher";
            after = [
              "graphical-session.target"
              # The Steam client calls into the XDG desktop portal frontend service
              # (org.freedesktop.portal.Realtime.MakeThreadHighPriorityWithPID) at shutdown,
              # ensure both services are stopped in the right order.
              "xdg-desktop-portal.service"
            ];
            partOf = [ "graphical-session.target" ];

            path = [ pkgs.steamos-stubs ];

            environment = {
              # Set input method modules for Qt/GTK that will show the Steam keyboard
              QT_IM_MODULE = "steam";
              GTK_IM_MODULE = "Steam";

              SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS = "0";

              STEAM_MULTIPLE_XWAYLANDS = "1";
              STEAM_MANGOAPP_PRESETS_SUPPORTED = "1";
              STEAM_USE_MANGOAPP = "1";

              MANGOHUD_CONFIG = "preset=3";
              MANGOHUD = "1";
            };

            serviceConfig = {
              ExecStart = "${pkgs.steam}/bin/steam -steamos3 -tenfoot -pipewire-dmabuf";
              KillMode = "mixed";
              TimeoutStopSec = 60;
            };
          };

          steamos-user-setup = {
            wants = [ "steamos-manager.service" ];
            after = [ "steamos-manager.service" ];

            path = [ pkgs.steamos-manager ];

            # For some reason this settings get overwritten, therefore put them here
            script = ''
              steamosctl set-default-desktop-session ${pkgs.cosmic-session}/share/wayland-sessions/cosmic.desktop
            '';

            serviceConfig.Type = "oneshot";

            wantedBy = [ "graphical-session.target" ];
          };
        };
      };
    };

    programs.steam = {
      enable = true;
      extraPackages = with pkgs; [
        steamos-stubs
        dmidecode
        xwininfo
      ];
    };

    services = {
      displayManager.sessionPackages = [ gamescope-wayland ];

      dbus.packages = with pkgs; [
        steamos-manager
        xdg-desktop-portal-gamescope
      ];

      # used by gamescope although logind maybe also works
      seatd.enable = true;

      greetd = {
        enable = true;
        settings = {
          default_session = {
            user = "tom";
            command = "${start-session}";
          };
        };
      };
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gamescope ];
      config."gamescope-session".default = [ "gamescope" ];
    };
  };
}
