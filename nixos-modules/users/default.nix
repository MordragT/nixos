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
              description = "The name of the main user to create on the system.";
              type = lib.types.str;
              default = "tom";
            };

            packages = lib.mkOption {
              description = "List of packages to install for the main user.";
              type = with lib.types; listOf package;
              default = [ ];
            };

            xdg = lib.mkOption {
              description = ''
                Options for the XDG Base Directory specification.
                Unlike home-manager, the files are not cleaned up on deactivation,
                therefore this assumes an impermanence setup.
              '';
              default = { };
              type =
                let
                  mainName = config.name;
                in
                lib.types.submodule (
                  { config, ... }:
                  {
                    options = {
                      enable = lib.mkEnableOption "XDG Base Directory";

                      configHome = lib.mkOption {
                        description = "Path to the XDG config home directory.";
                        type = lib.types.nonEmptyStr;
                        default = "/home/${mainName}/.config";
                      };

                      dataHome = lib.mkOption {
                        description = "Path to the XDG data home directory.";
                        type = lib.types.nonEmptyStr;
                        default = "/home/${mainName}/.local/share";
                      };

                      stateHome = lib.mkOption {
                        description = "Path to the XDG state home directory.";
                        type = lib.types.nonEmptyStr;
                        default = "/home/${mainName}/.local/state";
                      };

                      cacheHome = lib.mkOption {
                        description = "Path to the XDG cache home directory.";
                        type = lib.types.nonEmptyStr;
                        default = "/home/${mainName}/.cache";
                      };

                      configFile = lib.mkOption {
                        description = "Attribute set of config files to create in the XDG config home directory.";
                        default = { };
                        type = lib.types.attrsOf (
                          lib.types.submodule (
                            { name, ... }:
                            {
                              options = {
                                text = lib.mkOption {
                                  description = "Content of the config file.";
                                  type = with lib.types; nullOr str;
                                  default = null;
                                };

                                source = lib.mkOption {
                                  description = "Path to the source of the config file. Takes precedence over `text`.";
                                  type = with lib.types; nullOr path;
                                  default = null;
                                };

                                name = lib.mkOption {
                                  description = "Name of the config file. This is also used as the name of the systemd tmpfiles rule.";
                                  type = lib.types.str;
                                  readOnly = true;
                                  default = name;
                                };

                                target = lib.mkOption {
                                  description = "Path to the target of the config file.";
                                  type = lib.types.str;
                                  readOnly = true;
                                  default = "${config.configHome}/${name}";
                                };
                              };
                            }
                          )
                        );
                      };

                      dataFile = lib.mkOption {
                        description = "Attribute set of data files to create in the XDG data home directory.";
                        default = { };
                        type = lib.types.attrsOf (
                          lib.types.submodule (
                            { name, ... }:
                            {
                              options = {
                                text = lib.mkOption {
                                  description = "Content of the data file.";
                                  type = with lib.types; nullOr str;
                                  default = null;
                                };

                                source = lib.mkOption {
                                  description = "Path to the source of the data file. Takes precedence over `text`.";
                                  type = with lib.types; nullOr path;
                                  default = null;
                                };

                                name = lib.mkOption {
                                  description = "Name of the data file.";
                                  type = lib.types.str;
                                  readOnly = true;
                                  default = name;
                                };

                                target = lib.mkOption {
                                  description = "Path to the target of the data file.";
                                  type = lib.types.str;
                                  readOnly = true;
                                  default = "${config.dataHome}/${name}";
                                };
                              };
                            }
                          )
                        );
                      };

                      stateFile = lib.mkOption {
                        description = "Attribute set of state files to create in the XDG state home directory.";
                        default = { };
                        type = lib.types.attrsOf (
                          lib.types.submodule (
                            { name, ... }:
                            {
                              options = {
                                text = lib.mkOption {
                                  description = "Content of the state file.";
                                  type = with lib.types; nullOr str;
                                  default = null;
                                };

                                source = lib.mkOption {
                                  description = "Path to the source of the state file. Takes precedence over `text`.";
                                  type = with lib.types; nullOr path;
                                  default = null;
                                };

                                name = lib.mkOption {
                                  description = "Name of the state file.";
                                  type = lib.types.str;
                                  readOnly = true;
                                  default = name;
                                };

                                target = lib.mkOption {
                                  description = "Path to the target of the state file.";
                                  type = lib.types.str;
                                  readOnly = true;
                                  default = "${config.stateHome}/${name}";
                                };
                              };
                            }
                          )
                        );
                      };

                      cacheFile = lib.mkOption {
                        description = "Attribute set of cache files to create in the XDG cache home directory.";
                        default = { };
                        type = lib.types.attrsOf (
                          lib.types.submodule (
                            { name, ... }:
                            {
                              options = {
                                text = lib.mkOption {
                                  description = "Content of the cache file.";
                                  type = with lib.types; nullOr str;
                                  default = null;
                                };

                                source = lib.mkOption {
                                  description = "Path to the source of the cache file. Takes precedence over `text`.";
                                  type = with lib.types; nullOr path;
                                  default = null;
                                };

                                name = lib.mkOption {
                                  description = "Name of the cache file.";
                                  type = lib.types.str;
                                  readOnly = true;
                                  default = name;
                                };

                                target = lib.mkOption {
                                  description = "Path to the target of the cache file.";
                                  type = lib.types.str;
                                  readOnly = true;
                                  default = "${config.cacheHome}/${name}";
                                };
                              };
                            }
                          )
                        );
                      };
                    };
                  }
                );
            };

            extraGroups = lib.mkOption {
              description = "List of extra groups to add the main user to.";
              type = with lib.types; listOf str;
              default = [ ];
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
                              description = "Path to the source of the state tree";
                              example = "/state/home/tom";
                              type = lib.types.nonEmptyStr;
                            };

                            destination = lib.mkOption {
                              description = "Path to the destination of the state tree";
                              example = "/home/tom";
                              type = lib.types.nonEmptyStr;
                            };

                            method = lib.mkOption {
                              description = "Method on how to load the state tree leafs";
                              example = "symlink";
                              default = "mount";
                              type = lib.types.enum [
                                "symlink"
                                "mount"
                              ];
                            };

                            owner = lib.mkOption {
                              description = "The default user used to create missing directories";
                              example = "user";
                              default = "root";
                              type = lib.types.nonEmptyStr;
                            };

                            group = lib.mkOption {
                              description = "The default group used to create missing directories";
                              example = "users";
                              default = "root";
                              type = lib.types.nonEmptyStr;
                            };

                            mode = lib.mkOption {
                              description = "The default permission mode used to create missing directories";
                              example = "0700";
                              default = "0755";
                              type = lib.types.nonEmptyStr;
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
    systemd = {
      # TODO user service ?
      services.user-state = lib.mkIf cfg.main.state.enable {
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

      user.tmpfiles.users.${cfg.main.name}.rules =
        lib.optionals cfg.main.xdg.enable [
          "d ${cfg.main.xdg.configHome} 0700 ${cfg.main.name} users - -"
          "d ${cfg.main.xdg.dataHome} 0700 ${cfg.main.name} users - -"
          "d ${cfg.main.xdg.stateHome} 0700 ${cfg.main.name} users - -"
          "d ${cfg.main.xdg.cacheHome} 0700 ${cfg.main.name} users - -"
        ]
        ++ (lib.concatMap
          (
            cfg:
            let
              source =
                if cfg.source != null then
                  cfg.source
                else if cfg.text != null then
                  pkgs.writeText cfg.name cfg.text
                else
                  null;
            in
            lib.optionals (source != null) [
              "L+ ${cfg.target} - - - - ${source}"
            ]
          )
          (
            lib.attrValues cfg.main.xdg.configFile
            ++ lib.attrValues cfg.main.xdg.dataFile
            ++ lib.attrValues cfg.main.xdg.stateFile
            ++ lib.attrValues cfg.main.xdg.cacheFile
          )
        );
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
          "input" # check if this helps cemu controller, otherwise remove
          # TODO The following should be factored out in their respective modules.
          "docker"
          "vboxusers"
          "wireshark"
        ]
        ++ cfg.main.extraGroups;
        shell = pkgs.nushell;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIm/oTrV+ISStJ7Gb3ES7lZdCfya2TdEtkFZ/A1rqYEv tom@tom-pc"
        ];
      };
    };
  };
}
