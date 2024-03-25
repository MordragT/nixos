{
  envNoLibs,
  callPackage,
}:
callPackage ./base.nix rec {
  stdenv = envNoLibs;

  name = "pstl";
  targetDir = "runtimes";

  cmakeFlags = [
    "-DLLVM_ENABLE_RUNTIMES=${name}"
  ];
}
