{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.programs.nautilus;
in {
  options.mordrag.programs.nautilus = {
    enable = lib.mkEnableOption "Nautilus";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.gnome.nautilus];

    # quick previewer for nautilus
    services.gnome.sushi.enable = true;
  };
}
