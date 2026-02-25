{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.mordrag.environment.state;
  targets = mkOption {
    description = lib.mdDoc "List of source state trees and destination trees";
    default = [ ];
    type = types.listOf (
      types.submodule (
        {
          config,
          options,
          ...
        }:
        {
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
              type = types.enum [
                "symlink"
                "mount"
              ];
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
        }
      )
    );
  };
in
{
  options.mordrag.environment.state = {
    inherit targets;
    enable = mkEnableOption "Enable state loading";

    presets = {
      full = mkEnableOption "Enable the full impermanence preset.";
    };

    user = {
      enable = mkEnableOption "Enable user state loading";
      inherit targets;
    };
  };

  config =
    let
      fullPreset = [
        {
          source = "/nix/state/system/config";
          destination = "/etc";
          method = "mount";
          owner = "root";
          group = "root";
          mode = "0700";
        }
        {
          source = "/nix/state/system/state";
          destination = "/var/lib";
          method = "mount";
          owner = "root";
          group = "root";
          mode = "0700";
        }
        {
          source = "/nix/state/system/log";
          destination = "/var/log";
          method = "mount";
          owner = "root";
          group = "root";
          mode = "0700";
        }
        {
          source = "/nix/state/system/variable";
          destination = "/var";
          method = "mount";
          owner = "root";
          group = "root";
          mode = "0700";
        }
        # Home
        {
          source = "/nix/state/users/tom/home";
          destination = "/home/tom";
          method = "mount";
          owner = "tom";
          group = "users";
          mode = "0700";
        }
        {
          source = "/nix/state/users/tom/data";
          destination = "/home/tom";
          method = "mount";
          owner = "tom";
          group = "users";
          mode = "0700";
        }
        {
          source = "/nix/state/users/tom/config";
          destination = "/home/tom/.config";
          method = "mount";
          owner = "tom";
          group = "users";
          mode = "0700";
        }
        {
          source = "/nix/state/users/tom/share";
          destination = "/home/tom/.local/share";
          method = "mount";
          owner = "tom";
          group = "users";
          mode = "0700";
        }
        {
          source = "/nix/state/users/tom/state";
          destination = "/home/tom/.local/state";
          method = "mount";
          owner = "tom";
          group = "users";
          mode = "0700";
        }
      ];

      load-state =
        target:
        with target;
        "${pkgs.nushell}/bin/nu ${./load-state.nu} ${method} ${source} ${destination} ${owner} ${group} ${mode}\n";
    in
    mkIf cfg.enable {
      # 1. get all dirs to link/mount
      # 2. create script which will create parent directories if target dir does not exist
      # 3. depending on method create activation scripts

      system.activationScripts.load-state.text =
        let
          script = concatMapStrings load-state (cfg.targets ++ (lib.optionals cfg.presets.full fullPreset));
        in
        script;

      systemd.services.state = mkIf cfg.user.enable {
        enable = true;
        description = "State Binding";
        after = [ "systemd-logind.service" ];
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.util-linux ];
        script = concatMapStrings load-state cfg.user.targets;
      };
    };
}
