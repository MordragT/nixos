{
  envNoLibs,
  callPackage,
}:
callPackage ./base.nix {
  stdenv = envNoLibs;

  name = "libcxx";
  targetDir = "runtimes";

  cmakeFlags = [
    "-DLLVM_ENABLE_RUNTIMES=libcxx;libcxxabi;libunwind;"
  ];
}
