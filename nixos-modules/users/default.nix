{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.mordrag.users;
in
{
  options.mordrag.users = {
    enable = lib.mkEnableOption "Users";

    main = lib.mkOption {
      description = "Options for the main user of the system.";
      type = lib.types.submodule (
        { config, ... }:
        {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              default = "tom";
              description = "The name of the main user to create on the system.";
            };

            packages = lib.mkOption {
              type = with lib.types; listOf package;
              default = [ ];
              description = "List of packages to install for the main user.";
            };

            state = lib.mkOption {
              description = "Options for the state of the main user.";
              type = lib.types.submodule {
                options = {
                  enable = lib.mkEnableOption "User State";

                  targets = lib.mkOption {
                    description = "List of source state trees and destination trees for the main user.";
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
                              example = "/state/home/tom";
                              type = lib.types.nonEmptyStr;
                              description = "Path to the source of the state tree";
                            };

                            destination = lib.mkOption {
                              example = "/home/tom";
                              type = lib.types.nonEmptyStr;
                              description = "Path to the destination of the state tree";
                            };

                            method = lib.mkOption {
                              example = "symlink";
                              default = "mount";
                              type = lib.types.enum [
                                "symlink"
                                "mount"
                              ];
                              description = "Method on how to load the state tree leafs";
                            };

                            owner = lib.mkOption {
                              example = "user";
                              default = "root";
                              type = lib.types.nonEmptyStr;
                              description = "The default user used to create missing directories";
                            };

                            group = lib.mkOption {
                              example = "users";
                              default = "root";
                              type = lib.types.nonEmptyStr;
                              description = "The default group used to create missing directories";
                            };

                            mode = lib.mkOption {
                              example = "0700";
                              default = "0755";
                              type = lib.types.nonEmptyStr;
                              description = "The default permission mode used to create missing directories";
                            };
                          };
                        }
                      )
                    );
                    default = [
                      {
                        source = "/state/users/${config.name}/home";
                        destination = "/home/${config.name}";
                        method = "mount";
                        owner = config.name;
                        group = "users";
                        mode = "0700";
                      }
                      {
                        source = "/state/users/${config.name}/cache";
                        destination = "/home/${config.name}/.cache";
                        method = "mount";
                        owner = config.name;
                        group = "users";
                        mode = "0700";
                      }
                      {
                        source = "/state/users/${config.name}/config";
                        destination = "/home/${config.name}/.config";
                        method = "mount";
                        owner = config.name;
                        group = "users";
                        mode = "0700";
                      }
                      {
                        source = "/state/users/${config.name}/data";
                        destination = "/home/${config.name}/.local/share";
                        method = "mount";
                        owner = config.name;
                        group = "users";
                        mode = "0700";
                      }
                      {
                        source = "/state/users/${config.name}/state";
                        destination = "/home/${config.name}/.local/state";
                        method = "mount";
                        owner = config.name;
                        group = "users";
                        mode = "0700";
                      }
                    ];
                  };
                };
              };
            };
          };
        }
      );
    };
  };

  config = lib.mkIf cfg.enable {
    mordrag.state.directories = [ "/var/lib/userborn" ];

    services.userborn.enable = true;

    # 1. get all dirs to link/mount
    # 2. create script which will create parent directories if target dir does not exist
    # 3. depending on method create activation scripts
    systemd.services.user-state = lib.mkIf cfg.main.state.enable {
      enable = true;
      description = "User State Binding";

      after = [ "systemd-logind.service" ];

      path = [ pkgs.util-linux ];
      script =
        let
          load-state =
            target:
            with target;
            "${pkgs.nushell}/bin/nu ${./load-state.nu} ${method} ${source} ${destination} ${owner} ${group} ${mode}\n";
        in
        lib.concatMapStrings load-state cfg.main.state.targets;

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      wantedBy = [ "multi-user.target" ];
    };

    users = {
      mutableUsers = true;

      # To generate a hash to put in initialHashedPassword
      # you can do this:
      # $ nix-shell --run 'mkpasswd -m SHA-512 -s' -p mkpasswd

      users.root = {
        initialHashedPassword = "$6$bMyXd7NPiO./sD/f$enBP8XmgvHDiJh35ObyRVCPOrsScFI/AZL/mcIhACbqNAHKOkQLSjhlAvRanjNj9buWwB4uQxSLtqLRhBY5x/.";
        extraGroups = [ "root" ];
      };

      users.${cfg.main.name} = {
        inherit (cfg.main) packages;

        isNormalUser = true;
        initialHashedPassword = "$6$bMyXd7NPiO./sD/f$enBP8XmgvHDiJh35ObyRVCPOrsScFI/AZL/mcIhACbqNAHKOkQLSjhlAvRanjNj9buWwB4uQxSLtqLRhBY5x/.";
        extraGroups = [
          "wheel"
          "adbusers"
          "docker"
          "gamemode"
          "networkmanager"
          "vboxusers"
          "wireshark"
        ];
        shell = pkgs.nushell;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIm/oTrV+ISStJ7Gb3ES7lZdCfya2TdEtkFZ/A1rqYEv tom@tom-pc"
        ];
      };
    };
  };
}
