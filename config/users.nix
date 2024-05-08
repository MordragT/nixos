{pkgs, ...}: {
  users = {
    mutableUsers = true;

    # To generate a hash to put in initialHashedPassword
    # you can do this:
    # $ nix-shell --run 'mkpasswd -m SHA-512 -s' -p mkpasswd

    users.root = {
      initialHashedPassword = "$6$bMyXd7NPiO./sD/f$enBP8XmgvHDiJh35ObyRVCPOrsScFI/AZL/mcIhACbqNAHKOkQLSjhlAvRanjNj9buWwB4uQxSLtqLRhBY5x/.";
      extraGroups = ["root"];
    };

    users.tom = {
      isNormalUser = true;
      initialHashedPassword = "$6$bMyXd7NPiO./sD/f$enBP8XmgvHDiJh35ObyRVCPOrsScFI/AZL/mcIhACbqNAHKOkQLSjhlAvRanjNj9buWwB4uQxSLtqLRhBY5x/.";
      extraGroups = ["wheel" "docker" "gamemode"];
      shell = pkgs.nushellFull;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIm/oTrV+ISStJ7Gb3ES7lZdCfya2TdEtkFZ/A1rqYEv tom@tom-pc"
      ];
    };
  };
}
