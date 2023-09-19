{
  pkgs,
  pyPkgs,
}: let
  callPackage = pkgs.lib.callPackageWith (pkgs // pyPkgs // self);
  self = {
    dataclasses = callPackage ./dataclasses.nix {};
    future-annotations = callPackage ./future-annotations.nix {};
    pyqt6 = callPackage ./pyqt6.nix {};
    dandere2x = callPackage ./dandere2x.nix {};
    pylikwid = callPackage ./pylikwid.nix {};
  };
in
  self
