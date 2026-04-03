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
    ./bluetooth
    ./core
    ./fonts
    ./locale
    ./networking
    ./nix
    ./pipewire
    ./security
    ./users
    ./virtualisation
  ];

  options.mordrag.platform = {
    enable = lib.mkEnableOption "The basis that hosts built upon.";
  };

  config = lib.mkIf cfg.enable {
    mordrag.platform = {
      bluetooth.enable = true;
      core.enable = true;
      fonts.enable = true;
      locale.enable = true;
      networking.enable = true;
      nix.enable = true;
      pipewire.enable = true;
      security.enable = true;
      users.enable = true;
      virtualisation.enable = true;
    };
  };
}
