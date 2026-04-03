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
    hardware.bluetooth.enable = true;
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

    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };

    mordrag.platform = {
      core.enable = true;
      fonts.enable = true;
      nix.enable = true;
      pipewire.enable = true;
      virtualisation.enable = true;
    };
  };
}
