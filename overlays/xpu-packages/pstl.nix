{
  stdenv,
  callPackage,
}:
callPackage ./base.nix rec {
  inherit stdenv;

  name = "pstl";
  targetDir = "runtimes";

  cmakeFlags = [
    "-DLLVM_ENABLE_RUNTIMES=${name}"
  ];
}
