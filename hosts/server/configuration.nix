{
  pkgs,
  ...
}:
{
  mordrag = {
    boot = {
      enable = true;
      # TODO: this doesn't seem to work for first nixos-anywhere install
      # secureBoot = true;
    };
    desktop.cosmic = {
      enable = true;
      greeter = true;
    };
    disks = {
      enable = true;
      zram = true;
      mainPool.devices.main = "/dev/disk/by-id/nvme-WDC_PC_SN520_SDAPNUW-256G-1006_19321B800783";
      pools.snapshot.devices.main = "/dev/disk/by-id/ata-ST1000LM035-1RK172_WL16JC6M";
    };
    hardware.amd-r5-2400g = true;
    networking = {
      enable = true;
      lanMac = "9c:7b:ef:ae:e5:6d";
      wlanMac = "54:8c:a0:b1:5b:df";
    };
    platform.enable = true;
    programs = {
      git.enable = true;
      gnome-disks.enable = true;
      steam = {
        enable = true;
        compatPackages = [ pkgs.proton-ge-bin ];
      };
    };
    state = {
      enable = true;
      presets.full = true;
    };
    users = {
      enable = true;
      main = "tom";
    };
  };

  programs.chromium.enable = true;

  # For impermanence, TODO: movein presets full
  environment.etc = {
    machine-id.source = "/nix/state/system/config/machine-id";
  };

  environment.systemPackages = with pkgs; [
    loupe
    showtime
    papers
    # (
    #   # TODO create desktop file for this
    #   pkgs.writeShellScriptBin "steamos-session-select" ''
    #     echo $XDG_RUNTIME_DIR
    #     SESSION_SWITCH_FILE="$XDG_RUNTIME_DIR/steamos-session/switch"
    #     mkdir -p "$(dirname "$SESSION_SWITCH_FILE")"

    #     if [ -f "$SESSION_SWITCH_FILE" ]; then
    #       rm "$SESSION_SWITCH_FILE"
    #       # systemctl --user start cosmic-session.service
    #       steam -shutdown
    #       exec cosmic-session
    #     else
    #       touch "$SESSION_SWITCH_FILE"
    #       # systemctl --user start steam-session.service
    #       cosmic-osd log-out
    #       # No need to execute steam-gamescope here, as it will be executed by greetd
    #       # exec steam-gamescope
    #     fi
    #   ''
    # )
    # (pkgs.writeShellScriptBin "steamos-select-branch" ''
    #   case "$1" in
    #     "-c")
    #       # Current Branch
    #       echo "main"
    #       ;;
    #     "-l")
    #       # List Branches
    #       echo "main"
    #       ;;
    #     *)
    #       # Switch Branch
    #       ;;
    #   esac
    # '')
    # (pkgs.writeShellScriptBin "steamos-update" ''
    #   # Exit codes according to vendor:
    #   # 0 - update success
    #   # 1 - update error
    #   # 7 - no update available
    #   # 8 - need reboot
    #   exit 7
    # '')
  ];

  # TODO add as argument to own steam module
  # programs.steam.gamescopeSession = {
  #   args = [
  #     "-W 1280"
  #     "-H 720"
  #     # "-F fsr" # doesn't seem to work that well
  #     "--mangoapp"
  #     "--fullscreen" # gamescope introduces a lot of latency if not fullscreen
  #   ];
  #   steamArgs = [
  #     "-steamos3"
  #     "-tenfoot"
  #     "-pipewire-dmabuf"
  #   ];
  #   # somehow --mangoapp on gamescope doesn't find default config
  #   env.MANGOHUD_CONFIGFILE = "/home/tom/.config/MangoHud/MangoHud.conf";
  # };

  # services = {
  #   greetd = {
  #     enable = true;
  #     # settings.initial_session = {
  #     #   user = "tom";
  #     #   command = "cosmic-session";
  #     # };

  #     settings = {
  #       default_session = {
  #         user = "tom";
  #         command = "steam-gamescope";
  #       };
  #     };
  #   };
  # };
}
