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
      cat "$tmpdir/session.log"
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

    echo "Wayland display set ?"
    echo "$WAYLAND_DISPLAY"

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

    hardware.steam-hardware.enable = true;

    environment.systemPackages = [ pkgs.steamos-manager ];
    systemd.packages = [ pkgs.steamos-manager ];

    security.wrappers = {
      gamescope = {
        owner = "root";
        group = "root";
        source = "${pkgs.gamescope}/bin/gamescope";
        capabilities = "cap_sys_nice+pie";
      };
    };

    # Steam overrides this SOMETIMES seemingly for no reason
    # so we need to force it back to the user's choice.
    systemd.user.services.steamos-setup-cosmic-session = {
      wants = [ "steamos-manager.service" ];
      after = [ "steamos-manager.service" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.steamos-manager}/bin/steamosctl set-default-desktop-session ${pkgs.cosmic-session}/share/wayland-sessions/cosmic.desktop";
      };

      wantedBy = [ "graphical-session.target" ];
    };

    # # required for hdr? breaks gamescope ?
    # hardware.graphics = {
    #   enable32Bit = true;
    #   extraPackages = [ pkgs.gamescope-wsi ];
    #   extraPackages32 = [ pkgs.pkgsi686Linux.gamescope-wsi ];
    # };

    programs = {
      steam.enable = true;

      # gamescope = {
      #   enable = true;
      #   capSysNice = true;
      #   args = [
      #     # "-W 2560"
      #     # "-H 1440"
      #     # "-w 1920"
      #     # "-h 1080"
      #     # "-r 120"
      #     # "-F fsr" # doesn't seem to work that well
      #     # "--rt"
      #     # "--display-index 1"
      #     # "--immediate-flips"
      #     # "--backend sdl"
      #     "--mangoapp"
      #     "--fullscreen" # gamescope introduces a lot of latency if not fullscreen
      #   ];
      # };
    };

    services = {
      displayManager.sessionPackages = [ gamescopeSession ];

      # required by steamos-manager ?
      inputplumber.enable = true;

      # required by steam gamescope ? or maybe in combination with gamescope-wsi?
      seatd.enable = true;

      greetd = {
        enable = true;
        settings = {
          default_session = {
            user = "tom";
            command = "${steam-gamescope}/bin/steam-gamescope";
          };
        };
      };
    };
  };
}
