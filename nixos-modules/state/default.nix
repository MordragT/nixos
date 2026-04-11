{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.state;
in
{
  imports = [
    inputs.impermanence.nixosModules.default
  ];

  options.mordrag.state = {
    enable = lib.mkEnableOption "Enable state loading";

    directories = lib.mkOption {
      description = "List of directories to be mounted declaratively.";
      type = with lib.types; listOf (either str attrs);
      default = [ ];
    };

    files = lib.mkOption {
      description = "List of files to be symlinked declaratively.";
      type = with lib.types; listOf (either str attrs);
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      persistence."/state" = {
        enable = true;
        hideMounts = true;

        directories = cfg.directories ++ [
          "/var/lib/nixos"
          "/var/log"
        ];
        files = cfg.files ++ [
          "/etc/machine-id"
        ];
      };
    };
  };
}
