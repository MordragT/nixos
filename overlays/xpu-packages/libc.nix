{
  stdenv,
  callPackage,
}:
callPackage ./base.nix rec {
  inherit stdenv;

  name = "libc";
  targetDir = "runtimes";

  cmakeFlags = [
    "-DLLVM_ENABLE_RUNTIMES=${name}"
  ];
}
