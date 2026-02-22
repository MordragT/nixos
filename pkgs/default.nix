{ lib, ... }:
let
  by-attr = import ./by-attr;
  by-lang = import ./by-lang;
  by-name = import ./by-name;
  by-scope = import ./by-scope;
  pkgslib = import ./lib;
  overrides = import ./overrides;
  default = lib.composeManyExtensions [
    by-attr
    by-lang
    by-name
    by-scope
    overrides
    pkgslib
  ];
in
{
  flake.overlays = {
    inherit
      by-attr
      by-lang
      by-name
      by-scope
      overrides
      pkgslib
      default
      ;
  };

  perSystem =
    {
      pkgs,
      ...
    }:
    let
      finalPkgs = pkgs.extend default;

      packages = lib.mergeAttrsList [
        (by-name finalPkgs pkgs)
        (overrides finalPkgs pkgs)
      ];

      legacyPackages = lib.mergeAttrsList [
        (by-attr finalPkgs pkgs)
        (by-lang finalPkgs pkgs)
        (by-scope finalPkgs pkgs)
      ];
    in
    {
      inherit packages legacyPackages;
    };
}
