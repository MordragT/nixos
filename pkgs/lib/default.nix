_: prev:
let
  inherit (prev) callPackage;
in
{
  bazelPackage =
    callPackage "${prev.path}/pkgs/by-name/ba/bazel_8/build-support/bazelPackage.nix"
      { };
  fetchinteldeb = callPackage ./fetch-intel-deb { };
  steamCompatToolHook = callPackage ./steam-compat-tool-hook { };
  makeChromiumApp = callPackage ./make-chromium-app { };
}
