self: pkgs:
let
  myPkgs = import ./pkgs { inherit pkgs; };
in
rec
{
  python3 = pkgs.python3.override {
    packageOverrides = self: pyPkgs: import ./pkgs/python { inherit pkgs pyPkgs; };
  };
  dandere2x = pkgs.python3Packages.dandere2x;
} // myPkgs
