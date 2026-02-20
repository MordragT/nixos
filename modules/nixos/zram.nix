{
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.zram;
in
{
  options.mordrag.zram = {
    enable = lib.mkEnableOption "ZRam";
  };

  config = lib.mkIf cfg.enable {
    # TODO
  };
}
