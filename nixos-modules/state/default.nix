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
    # Ensure for dynamic user services that this directory already exists with the correct permissions
    systemd.tmpfiles.rules = [
      # For /var/lib/private
      "d /var/lib/private 0700 ${config.users.users.root.name} ${config.users.groups.root.name} -"
      "d /state/var/lib/private 0700 ${config.users.users.root.name} ${config.users.groups.root.name} -"

      # For /var/cache/private
      "d /var/cache/private 0700 ${config.users.users.root.name} ${config.users.groups.root.name} -"
      "d /state/var/cache/private 0700 ${config.users.users.root.name} ${config.users.groups.root.name} -"
    ];

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
