{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.state;
  user = config.mordrag.users.main;
  targets = lib.mkOption {
    description = lib.mdDoc "List of source state trees and destination trees";
    default = [ ];
    type = lib.types.listOf (
      lib.types.submodule (
        {
          config,
          options,
          ...
        }:
        {
          options = {
            source = lib.mkOption {
              example = "/nix/state/home/tom";
              type = lib.types.nonEmptyStr;
              description = lib.mdDoc "Path to the source of the state tree";
            };

            destination = lib.mkOption {
              example = "/home/tom";
              type = lib.types.nonEmptyStr;
              description = lib.mdDoc "Path to the destination of the state tree";
            };

            method = lib.mkOption {
              example = "symlink";
              default = "mount";
              type = lib.types.enum [
                "symlink"
                "mount"
              ];
              description = lib.mdDoc "Method on how to load the state tree leafs";
            };

            owner = lib.mkOption {
              example = "user";
              default = "root";
              type = lib.types.nonEmptyStr;
              description = lib.mdDoc "The default user used to create missing directories";
            };

            group = lib.mkOption {
              example = "users";
              default = "root";
              type = lib.types.nonEmptyStr;
              description = lib.mdDoc "The default group used to create missing directories";
            };

            mode = lib.mkOption {
              example = "0700";
              default = "0755";
              type = lib.types.nonEmptyStr;
              description = lib.mdDoc "The default permission mode used to create missing directories";
            };
          };
        }
      )
    );
  };
in
{
  options.mordrag.state = {
    inherit targets;
    enable = lib.mkEnableOption "Enable state loading";

    presets = {
      full = lib.mkEnableOption "Enable the full impermanence preset.";
    };

    user = {
      enable = lib.mkEnableOption "Enable user state loading";
      inherit targets;
    };
  };

  config =
    let
      fullPreset = [
        {
          source = "/state/system/config";
          destination = "/etc";
          method = "mount";
          owner = "root";
          group = "root";
          mode = "0700";
        }
        {
          source = "/state/system/state";
          destination = "/var/lib";
          method = "mount";
          owner = "root";
          group = "root";
          mode = "0700";
        }
        {
          source = "/state/system/log";
          destination = "/var/log";
          method = "mount";
          owner = "root";
          group = "root";
          mode = "0700";
        }
        {
          source = "/state/system/cache";
          destination = "/var/cache";
          method = "mount";
          owner = "root";
          group = "root";
          mode = "0700";
        }
        {
          source = "/state/system/spool";
          destination = "/var/spool";
          method = "mount";
          owner = "root";
          group = "root";
          mode = "0700";
        }
        {
          source = "/state/system/secrets";
          destination = "/var/secrets";
          method = "mount";
          owner = "root";
          group = "root";
          mode = "0700";
        }
        # Home
        {
          source = "/state/users/${user}/home";
          destination = "/home/${user}";
          method = "mount";
          owner = user;
          group = "users";
          mode = "0700";
        }
        {
          source = "/state/users/${user}/cache";
          destination = "/home/${user}/.cache";
          method = "mount";
          owner = user;
          group = "users";
          mode = "0700";
        }
        {
          source = "/state/users/${user}/config";
          destination = "/home/${user}/.config";
          method = "mount";
          owner = user;
          group = "users";
          mode = "0700";
        }
        {
          source = "/state/users/${user}/data";
          destination = "/home/${user}/.local/share";
          method = "mount";
          owner = user;
          group = "users";
          mode = "0700";
        }
        {
          source = "/state/users/${user}/state";
          destination = "/home/${user}/.local/state";
          method = "mount";
          owner = user;
          group = "users";
          mode = "0700";
        }
      ];

      load-state =
        target:
        with target;
        "${pkgs.nushell}/bin/nu ${./load-state.nu} ${method} ${source} ${destination} ${owner} ${group} ${mode}\n";
    in
    lib.mkIf cfg.enable {
      # 1. get all dirs to link/mount
      # 2. create script which will create parent directories if target dir does not exist
      # 3. depending on method create activation scripts

      system.activationScripts.load-state.text =
        let
          script = lib.concatMapStrings load-state (
            cfg.targets ++ (lib.optionals cfg.presets.full fullPreset)
          );
        in
        script;

      systemd.services.state = lib.mkIf cfg.user.enable {
        enable = true;
        description = "State Binding";
        after = [ "systemd-logind.service" ];
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.util-linux ];
        script = lib.concatMapStrings load-state cfg.user.targets;
      };
    };
}
