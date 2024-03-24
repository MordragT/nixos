{
  stdenv,
  callPackage,
}:
callPackage ./base.nix {
  inherit stdenv;

  name = "libcxx";
  targetDir = "runtimes";

  cmakeFlags = [
    "-DLLVM_ENABLE_RUNTIMES=libcxx;libcxxabi;libunwind;"
  ];
}
