{pkgs}: let
  callPackage = pkgs.callPackage;
  dpcpp-bin-unwrapped = callPackage ./dpcpp-bin.nix {};
  dpcpp-unwrapped = callPackage ./dpcpp.nix {};
  clang-bin = callPackage ./toolchain.nix {cc = dpcpp-bin-unwrapped;};
  clang = callPackage ./toolchain.nix {cc = dpcpp-unwrapped;};
in {
  inherit clang clang-bin;
  sycl = dpcpp-bin-unwrapped;
  stdenv = callPackage ./stdenv.nix {toolchain = clang-bin;};
}
