{
  config,
  lib,
  pkgs,
  ...
}: let
  bottles = config.mordrag.bottles;
in
  with lib; {
    options.mordrag.bottles = mkOption {
      description = lib.mdDoc "List of wine applications";
      type = types.attrsOf (types.submodule {
        options = {
          wine-env = mkOption {
            type = types.package;
            default = pkgs.mkWineEnv {
              pname = "wine-wow";
            };
            description = lib.mdDoc "Wine environment to use";
          };

          directory = mkOption {
            example = "/home/tom/.local/share/bottles/name";
            type = types.nonEmptyStr;
            description = lib.mdDoc "Path to the bottles directory.";
          };

          pre-cmd = mkOption {
            example = "gamescope -W 2560 -H 1440 --";
            default = "";
            type = types.str;
            description = lib.mdDoc "Command Prefix";
          };

          cmd = mkOption {
            example = "drive_c/Program Files/Rockstar Games/Launcher/Launcher.exe";
            type = types.nonEmptyStr;
            description = lib.mdDoc "The Command to execute";
          };

          post-cmd = mkOption {
            example = "-window";
            default = "";
            type = types.str;
            description = lib.mdDoc "Command Postfix";
          };
        };
      });
    };

    config = {
      home.packages =
        mapAttrsToList (name: value: (pkgs.mkWineApp {
          inherit name;
          inherit (value) wine-env directory pre-cmd cmd post-cmd;
        }))
        bottles;
    };
  }
