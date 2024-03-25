{
  envNoLibs,
  callPackage,
}:
callPackage ./base.nix rec {
  stdenv = envNoLibs;

  name = "openmp";
  targetDir = "runtimes";

  cmakeFlags = [
    "-DLLVM_ENABLE_RUNTIMES=${name}"
  ];
}
