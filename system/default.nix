{ pkgs, config, lib, ... }:
{
  imports =
    [ 
      ./programs.nix
      ./config.nix
      ./desktop.nix
    ];
}