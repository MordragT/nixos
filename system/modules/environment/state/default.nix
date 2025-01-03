{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mordrag.environment.state;
  targets = mkOption {
    description = lib.mdDoc "List of source state trees and destination trees";
    default = [];
    type = types.listOf (types.submodule ({
      config,
      options,
      ...
    }: {
      options = {
        source = mkOption {
          example = "/nix/state/home/tom";
          type = types.nonEmptyStr;
          description = lib.mdDoc "Path to the source of the state tree";
        };

        destination = mkOption {
          example = "/home/tom";
          type = types.nonEmptyStr;
          description = lib.mdDoc "Path to the destination of the state tree";
        };

        method = mkOption {
          example = "symlink";
          default = "mount";
          type = types.enum ["symlink" "mount"];
          description = lib.mdDoc "Method on how to load the state tree leafs";
        };

        owner = mkOption {
          example = "user";
          default = "root";
          type = types.nonEmptyStr;
          description = lib.mdDoc "The default user used to create missing directories";
        };

        group = mkOption {
          example = "users";
          default = "root";
          type = types.nonEmptyStr;
          description = lib.mdDoc "The default group used to create missing directories";
        };

        mode = mkOption {
          example = "0700";
          default = "0755";
          type = types.nonEmptyStr;
          description = lib.mdDoc "The default permission mode used to create missing directories";
        };
      };
    }));
  };
in {
  options.mordrag.environment.state = {
    inherit targets;
    enable = mkEnableOption "Enable state loading";
    user = {
      enable = mkEnableOption "Enable user state loading";
      inherit targets;
    };
  };

  config = let
    load-state = target: with target; "${pkgs.nushell}/bin/nu ${./load-state.nu} ${method} ${source} ${destination} ${owner} ${group} ${mode}\n";
  in
    mkIf cfg.enable {
      # 1. get all dirs to link/mount
      # 2. create script which will create parent directories if target dir does not exist
      # 3. depending on method create activation scripts

      system.activationScripts.load-state.text = let
        script = concatMapStrings load-state cfg.targets;
      in
        script;

      systemd.services.state = mkIf cfg.user.enable {
        enable = true;
        description = "State Binding";
        after = ["systemd-logind.service"];
        wantedBy = ["multi-user.target"];
        path = [pkgs.util-linux];
        script = concatMapStrings load-state cfg.user.targets;
      };
    };
}
