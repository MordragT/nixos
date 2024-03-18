{
  pkgs,
  pyPkgs,
}: let
  callPackage = pkgs.lib.callPackageWith (pkgs // pyPkgs);
in {
  xpu = import ./xpu {
    inherit callPackage;
  };
}
