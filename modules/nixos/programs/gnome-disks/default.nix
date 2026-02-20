{
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.programs.gnome-disks;
in
{
  options.mordrag.programs.gnome-disks = {
    enable = lib.mkEnableOption "Gnome Disks";
  };

  config = lib.mkIf cfg.enable {
    services.udisks2.enable = true;
    programs.gnome-disks.enable = true;
  };
}
