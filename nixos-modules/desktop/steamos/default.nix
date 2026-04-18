{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.desktop.steamos;

  steam-gamescope = pkgs.writeShellScriptBin "steam-gamescope" ''
    export MANGOHUD_CONFIGFILE="$HOME/.config/MangoHud/MangoHud.conf"

    # Setup socket for gamescope
    # Create run directory file for startup and stats sockets
    tmpdir="$(mktemp -p "$XDG_RUNTIME_DIR" -d -t gamescope.XXXXXXX)"
    socket="$tmpdir/startup.socket"
    stats="$tmpdir/stats.pipe"

    export GAMESCOPE_STATS="$stats"
    mkfifo -- "$stats"
    mkfifo -- "$socket"

    # Start gamescope compositor, log it's output and background it
    if ! /run/wrappers/bin/gamescope \
        --steam \
        --backend drm \
        --ready-fd "$socket" \
        --stats-path "$stats" \
        >"$tmpdir/session.log" 2>&1; then
      echo "gamescope exited with code $?" >> "$tmpdir/session.log"
      exit 1
    fi &
    gamescope_pid="$!"

    if read -r -t 16 response_x_display response_wl_display <>"$socket"; then
      export DISPLAY="$response_x_display"
      export GAMESCOPE_WAYLAND_DISPLAY="$response_wl_display"
      # We're done!
    else
      echo "gamescope failed"
      kill -9 "$gamescope_pid"
      wait -n "$gamescope_pid"
      exit 1
      # Systemd or Session manager will have to restart session
    fi

    # Start Steam
    steam -steamos3 -tenfoot -pipewire-dmabuf -clientbeta steamdeck_publicbeta

    # When the client exits, kill gamescope nicely
    kill $gamescope_pid
  '';

  gamescopeSession =
    (pkgs.makeDesktopItem {
      name = "steam";
      desktopName = "Steam";
      comment = "A desktop session for running Steam in gamescope";
      exec = "${steam-gamescope}/bin/steam-gamescope";
      type = "Application";
      destination = "/share/wayland-sessions";
    }).overrideAttrs
      (_: {
        passthru.providedSessions = [ "steam" ];
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

    hardware.steam-hardware.enable = true;

    environment = {
      systemPackages = with pkgs; [
        dmidecode
        steamos-manager
        steamos-stubs
      ];

      # DMI stuff needs to match
      etc."steamos-manager/config.toml".source = ./config.toml;

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
    systemd.packages = [ pkgs.steamos-manager ];
    services.dbus.packages = [ pkgs.steamos-manager ];

    systemd.services = {
      steamos-manager = {
        overrideStrategy = "asDropin";
        # FIXME: should probably be done upstream
        after = [ "inputplumber.service" ];
      };

      # This doesn't work and errors with file not found error somehow
      # steamos-setup = {
      #   wants = [ "steamos-manager.service" ];
      #   after = [ "steamos-manager.service" ];

      #   path = [ pkgs.steamos-manager ];

      #   # For some reason this settings get overwritten, therefore put them here
      #   script = ''
      #     steamosctl set-wifi-backend ${config.networking.networkmanager.wifi.backend}
      #   '';

      #   serviceConfig.Type = "oneshot";

      #   wantedBy = [ "multi-user.target" ];
      # };
    };

    security.wrappers = {
      gamescope = {
        owner = "root";
        group = "root";
        source = "${pkgs.gamescope}/bin/gamescope";
        capabilities = "cap_sys_nice+pie";
      };
    };

    systemd.user.services.steamos-user-setup = {
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

    programs.steam = {
      enable = true;
      extraPackages = with pkgs; [
        steamos-stubs
        dmidecode
        xwininfo
      ];
    };

    services = {
      displayManager.sessionPackages = [ gamescopeSession ];

      # required by steamos-manager ?
      inputplumber.enable = true;

      # used by gamescope although logind maybe also works
      seatd.enable = true;

      # needed by steamos-manager ?
      fwupd.enable = true;

      greetd = {
        enable = true;
        settings = {
          default_session = {
            user = "tom";
            command = "${steam-gamescope}/bin/steam-gamescope";
            # command = "cosmic-session";
          };
        };
      };
    };
  };
}
