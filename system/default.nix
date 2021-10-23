{ pkgs, config, lib, ... }:
{
  imports =
    [ 
      ./programs.nix
      ./config.nix
      ./gnome.nix
    ];
}