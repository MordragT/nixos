{pkgs, ...}: {
  users = {
    mutableUsers = true;

    users.root = {
      initialPassword = "toor";
      extraGroups = ["root"];
    };

    users.tom = {
      isNormalUser = true;
      initialPassword = "tom";
      extraGroups = ["wheel" "docker" "gamemode"];
      shell = pkgs.nushellFull;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIm/oTrV+ISStJ7Gb3ES7lZdCfya2TdEtkFZ/A1rqYEv tom@tom-pc"
      ];
    };
  };
}
