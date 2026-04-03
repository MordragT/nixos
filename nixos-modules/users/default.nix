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
      type = lib.types.str;
      default = "tom";
      description = "The main user to create on the system.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.userborn.enable = true;

    users = {
      mutableUsers = true;

      # To generate a hash to put in initialHashedPassword
      # you can do this:
      # $ nix-shell --run 'mkpasswd -m SHA-512 -s' -p mkpasswd

      users.root = {
        initialHashedPassword = "$6$bMyXd7NPiO./sD/f$enBP8XmgvHDiJh35ObyRVCPOrsScFI/AZL/mcIhACbqNAHKOkQLSjhlAvRanjNj9buWwB4uQxSLtqLRhBY5x/.";
        extraGroups = [ "root" ];
      };

      users.${cfg.main} = {
        isNormalUser = true;
        initialHashedPassword = "$6$bMyXd7NPiO./sD/f$enBP8XmgvHDiJh35ObyRVCPOrsScFI/AZL/mcIhACbqNAHKOkQLSjhlAvRanjNj9buWwB4uQxSLtqLRhBY5x/.";
        extraGroups = [
          "wheel"
          "docker"
          "gamemode"
          "wireshark"
          "adbusers"
          "vboxusers"
        ];
        shell = pkgs.nushell;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIm/oTrV+ISStJ7Gb3ES7lZdCfya2TdEtkFZ/A1rqYEv tom@tom-pc"
        ];
      };
    };

  };
}
