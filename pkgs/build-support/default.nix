self: pkgs: let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
in {
  bazelPackage = callPackage "${pkgs.path}/pkgs/by-name/ba/bazel_8/build-support/bazelPackage.nix" {};
  fetchinteldeb = callPackage ./fetch-intel-deb {};
  steamCompatToolHook = callPackage ./steam-compat-tool-hook {};
  makeChromiumApp = callPackage ./make-chromium-app {};
}
