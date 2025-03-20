self: pkgs: let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
in {
  fetchinteldeb = callPackage ./fetch-intel-deb {};
  steamCompatToolHook = callPackage ./steam-compat-tool-hook {};
  makeChromiumApp = callPackage ./make-chromium-app {};
}
