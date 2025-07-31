{
  lib,
  config,
  pkgs,
  ...
}: {
  # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";

  networking.hostName = "tom-server";

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
      intel-media-driver
      intel-vaapi-driver
    ];
  };

  # nix.settings = {
  #   substituters = ["https://store.local"];
  #   trusted-public-keys = ["store.local:ohyp4iA+P1zKhD/nXWjrQtCB6+e69d/vgLuWD3/mnZ8="];
  # };

  mordrag.desktop.cosmic.enable = true;

  mordrag.programs.gnome-disks.enable = true;

  environment.systemPackages = with pkgs; [
    pulsemixer
    loupe
    showtime
    papers
    (
      pkgs.writeShellScriptBin "steamos-session-select" ''
        steam -shutdown
        exec cosmic-session
      ''
    )
    (
      pkgs.writeShellScriptBin "steamos-select-branch" ''
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
      ''
    )
    (
      pkgs.writeShellScriptBin "steamos-update" ''
        # Exit codes according to vendor:
        # 0 - update success
        # 1 - update error
        # 7 - no update available
        # 8 - need reboot
        exit 7
      ''
    )
  ];

  mordrag.programs.steam = {
    enable = true;
    compatPackages = with pkgs; [
      proton-ge-custom
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

  services.greetd = {
    enable = true;
    settings.default_session = {
      user = "tom";
      command = "steam-gamescope";
      # command = "cosmic-session";
    };
  };

  # jovian.steam = {
  #   enable = true;
  #   autoStart = true;
  #   user = "tom";
  #   desktopSession = "cosmic";
  # };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };
}
