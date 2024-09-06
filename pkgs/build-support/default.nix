self: pkgs: let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
in {
  fetchinteldeb = callPackage ./fetch-intel-deb {};
  steamCompatToolHook = callPackage ./steam-compat-tool-hook {};
  mkWineEnv = callPackage ./make-wine-env {};
  mkWineApp = callPackage ./make-wine-app {};
}
