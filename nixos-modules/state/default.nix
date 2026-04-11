{
  inputs,
  config,
  lib,
  pkgs,
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

    machine-id = lib.mkOption {
      description = "Machine ID to be used for the system.";
      type = lib.types.nonEmptyStr;
    };

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
      etc.machine-id.text = cfg.machine-id;

      persistence."/state" = {
        enable = true;
        hideMounts = true;

        directories = cfg.directories ++ [
          "/var/lib/nixos"
          "/var/log"
        ];
        inherit (cfg) files;
      };
    };
  };
}
