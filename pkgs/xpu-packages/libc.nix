{
  envNoLibs,
  callPackage,
}:
callPackage ./base.nix rec {
  stdenv = envNoLibs;

  name = "libc";
  targetDir = "runtimes";

  cmakeFlags = [
    "-DLLVM_ENABLE_RUNTIMES=${name}"
  ];
}
