{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.desktop.steamos;

  steam-gamescope = pkgs.writeShellScriptBin "steam-gamescope" ''
    # Session variables
    export XDG_SESSION_TYPE=x11
    export XDG_SESSION_DESKTOP=steam-gamescope
    export XDG_CURRENT_DESKTOP=steam-gamescope

    # Setup socket for gamescope
    # Create run directory file for startup and stats sockets
    tmpdir="$(mktemp -p "$XDG_RUNTIME_DIR" -d -t gamescope.XXXXXXX)"
    socket="$tmpdir/startup.socket"
    stats="$tmpdir/stats.pipe"
    mkfifo -- "$stats"
    mkfifo -- "$socket"

    export GAMESCOPE_STATS="$stats"

    # Enable the gamescope WSI extension to allow gamescope to manage buffers directly
    export ENABLE_GAMESCOPE_WSI=1
    # Don't wait for buffers to idle on the client side before sending them to gamescope
    export vk_xwayland_wait_ready=false

    # Start gamescope compositor, log it's output and background it
    if ! /run/wrappers/bin/gamescope \
        --backend drm \
        --ready-fd "$socket" \
        --stats-path "$stats" \
        --output-width 1920 \
        --output-height 1080 \
        --filter fsr \
        --steam \
        --mangoapp \
        --xwayland-count 2 \
        >"$tmpdir/session.log" 2>&1; then
      echo "gamescope exited with code $?" >> "$tmpdir/session.log"
      exit 1
    fi &
    gamescope_pid="$!"

    if read -r -t 16 response_x_display response_wl_display <>"$socket"; then
      export DISPLAY="$response_x_display"
      export GAMESCOPE_WAYLAND_DISPLAY="$response_wl_display"
    else
      echo "gamescope failed"
      kill -9 "$gamescope_pid"
      wait -n "$gamescope_pid"
      exit 1
      # Systemd or Session manager will have to restart session
    fi

    # Sync to systemd user manager (so user services see Wayland/Display)
    systemctl --user import-environment \
        DISPLAY GAMESCOPE_WAYLAND_DISPLAY \
        XDG_SESSION_TYPE XDG_CURRENT_DESKTOP

    # Set input method modules for Qt/GTK that will show the Steam keyboard
    export QT_IM_MODULE=steam
    export GTK_IM_MODULE=Steam

    export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0

    export STEAM_MULTIPLE_XWAYLANDS=1
    export STEAM_MANGOAPP_PRESETS_SUPPORTED=1
    export STEAM_USE_MANGOAPP=1

    export MANGOHUD_CONFIG=preset=3
    export MANGOHUD=1

    # Start Steam
    steam -steamos3 -tenfoot -pipewire-dmabuf

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

    hardware = {
      steam-hardware.enable = true;
      graphics.extraPackages = [ pkgs.gamescope-wsi ];
    };

    environment = {
      systemPackages = with pkgs; [
        dmidecode
        steamos-manager
        steamos-stubs
        mangohud
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

      services.steamos-manager = {
        overrideStrategy = "asDropin";
        # FIXME: should probably be done upstream
        after = [ "inputplumber.service" ];
      };

      user.services.steamos-user-setup = {
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

    programs.steam = {
      enable = true;
      extraPackages = with pkgs; [
        steamos-stubs
        dmidecode
        xwininfo
        mangohud
      ];
    };

    services = {
      displayManager.sessionPackages = [ gamescopeSession ];

      dbus.packages = with pkgs; [
        steamos-manager
        xdg-desktop-portal-gamescope
      ];

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

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gamescope ];
    };
  };
}
