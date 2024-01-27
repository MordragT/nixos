{
  pkgs,
  pyPkgs,
}: let
  callPackage = pkgs.lib.callPackageWith (pkgs // pyPkgs // self);
  self = rec {
    dataclasses = callPackage ./dataclasses.nix {};
    future-annotations = callPackage ./future-annotations.nix {};
    pyqt6 = callPackage ./pyqt6.nix {};
    dandere2x = callPackage ./dandere2x.nix {};
    xpu = import ./xpu {
      inherit callPackage;
    };
  };
in
  self
