{
  pkgs,
  unified-runtime,
}: let
  callPackage = pkgs.lib.callPackageWith (pkgs // {unified-runtime = unified-runtime;});
  dpcpp-bin-unwrapped = callPackage ./dpcpp-bin.nix {};
  dpcpp-unwrapped = callPackage ./dpcpp.nix {};
  dpcpp-bin = callPackage ./toolchain.nix {cc = dpcpp-bin-unwrapped;};
  dpcpp = callPackage ./toolchain.nix {cc = dpcpp-unwrapped;};
in {
  inherit dpcpp dpcpp-bin;
  stdenv = callPackage ./stdenv.nix {toolchain = dpcpp;};
}
