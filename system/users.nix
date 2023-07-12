{ pkgs, ... }:
{
  users = {
    mutableUsers = true;

    users.root = {
      extraGroups = [ "root" ];
    };

    users.tom = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.nushell;
    };
  };
}
