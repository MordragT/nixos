{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    openconnect_unstable
    hurl # like curl but better
  ];
}
