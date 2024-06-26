self: pkgs: let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
in {
  fetchinteldeb = import ./fetchinteldeb {inherit (pkgs) fetchurl;};
}
