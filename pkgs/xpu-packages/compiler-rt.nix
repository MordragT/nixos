{
  envNoLibs,
  callPackage,
}:
callPackage ./base.nix rec {
  stdenv = envNoLibs;

  name = "compiler-rt";
  targetDir = "runtimes";

  cmakeFlags = [
    "-DLLVM_ENABLE_RUNTIMES=${name}"
  ];
}
