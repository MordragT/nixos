{
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.platform;
in
{
  imports = [
    ./core
    ./fonts
    ./nix
    ./pipewire
    ./virtualisation
  ];

  options.mordrag.platform = {
    enable = lib.mkEnableOption "The basis that hosts built upon.";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

    time.timeZone = "Europe/Berlin";
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "us";

    security = {
      acme = {
        acceptTerms = true;
        defaults.email = "contact.mordrag+acme@gmail.de";
      };
      sudo.enable = false;
      sudo-rs.enable = true;
    };

    services = {
      journald.extraConfig = ''
        SystemMaxUse=2G
      '';

      openssh = {
        enable = true;
        settings.PasswordAuthentication = false;

        hostKeys = [
          {
            bits = 4096;
            path = "/state/etc/ssh/ssh_host_rsa_key";
            type = "rsa";
          }
          {
            path = "/state/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
        ];
      };

      scx = {
        enable = true;
        scheduler = "scx_lavd";
      };
    };

    mordrag = {
      platform = {
        core.enable = true;
        fonts.enable = true;
        nix.enable = true;
        pipewire.enable = true;
        virtualisation.enable = true;
      };

      state.directories = [
        "/var/lib/bluetooth"
      ];
    };
  };
}
