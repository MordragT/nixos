{ pkgs, config, lib, ... }:
{
  imports =
    [ 
      ./programs.nix
      ./services.nix
      ./config.nix
      ./gnome.nix
    ];
}