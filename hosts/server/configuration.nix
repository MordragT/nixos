{
  pkgs,
  ...
}:
{
  mordrag.bluetooth.enable = true;
  mordrag.core.enable = true;
  mordrag.fonts.enable = true;
  mordrag.locale.enable = true;
  mordrag.networking.enable = true;
  mordrag.nix.enable = true;
  mordrag.pipewire.enable = true;
  mordrag.secrets.enable = true;
  mordrag.security.enable = true;
  mordrag.users.enable = true;
  mordrag.virtualisation.enable = true;

  mordrag.boot.enable = true;
  mordrag.hardware.intel-n4100 = true;

  # nix.settings = {
  #   substituters = [ "https://harmonia.mordrag.de" ];
  #   trusted-public-keys = [ "harmonia.mordrag.de:ohyp4iA+P1zKhD/nXWjrQtCB6+e69d/vgLuWD3/mnZ8=" ];
  # };

  mordrag.desktop.cosmic.enable = true;

  mordrag.programs.gnome-disks.enable = true;

  environment.systemPackages = with pkgs; [
    pulsemixer
    loupe
    showtime
    papers
    (
      # TODO create desktop file for this
      pkgs.writeShellScriptBin "steamos-session-select" ''
        echo $XDG_RUNTIME_DIR
        SESSION_SWITCH_FILE="$XDG_RUNTIME_DIR/steamos-session/switch"
        mkdir -p "$(dirname "$SESSION_SWITCH_FILE")"

        if [ -f "$SESSION_SWITCH_FILE" ]; then
          rm "$SESSION_SWITCH_FILE"
          # systemctl --user start cosmic-session.service
          steam -shutdown
          exec cosmic-session
        else
          touch "$SESSION_SWITCH_FILE"
          # systemctl --user start steam-session.service
          cosmic-osd log-out
          # No need to execute steam-gamescope here, as it will be executed by greetd
          # exec steam-gamescope
        fi
      ''
    )
    (pkgs.writeShellScriptBin "steamos-select-branch" ''
      case "$1" in
        "-c")
          # Current Branch
          echo "main"
          ;;
        "-l")
          # List Branches
          echo "main"
          ;;
        *)
          # Switch Branch
          ;;
      esac
    '')
    (pkgs.writeShellScriptBin "steamos-update" ''
      # Exit codes according to vendor:
      # 0 - update success
      # 1 - update error
      # 7 - no update available
      # 8 - need reboot
      exit 7
    '')
  ];

  mordrag.programs.steam = {
    enable = true;
    compatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
  # TODO add as argument to own steam module
  programs.steam.gamescopeSession = {
    args = [
      "-W 1280"
      "-H 720"
      # "-F fsr" # doesn't seem to work that well
      "--mangoapp"
      "--fullscreen" # gamescope introduces a lot of latency if not fullscreen
    ];
    steamArgs = [
      "-steamos3"
      "-tenfoot"
      "-pipewire-dmabuf"
    ];
    # somehow --mangoapp on gamescope doesn't find default config
    env.MANGOHUD_CONFIGFILE = "/home/tom/.config/MangoHud/MangoHud.conf";
  };

  # Simple user services don't work because sessions need special permission e.g. to get drm master via loginctl activate-session (if I understand it correctly)
  # maybe uwsm can help here but not sure if it works with cosmic
  # systemd.user.services.steam-session = {
  #   description = "Steam Session";
  #   conflicts = ["cosmic-session.service"];
  #   requires = ["graphical-session.target"];
  #   after = ["graphical-session.target"];

  #   serviceConfig = {
  #     Type = "simple";
  #     ExecStart = "steam-gamescope";
  #   };
  # };

  # systemd.user.services.cosmic-session = {
  #   description = "Cosmic Session";
  #   conflicts = ["steam-session.service"];
  #   requires = ["graphical-session.target"];
  #   after = ["graphical-session.target"];

  #   serviceConfig = {
  #     Type = "simple";
  #     ExecStart = "${pkgs.cosmic-session}/bin/cosmic-session";
  #   };
  # };

  services.greetd = {
    enable = true;
    # settings.initial_session = {
    #   user = "tom";
    #   command = "cosmic-session";
    # };

    settings.default_session = {
      user = "tom";
      command = "steam-gamescope";
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };
}
