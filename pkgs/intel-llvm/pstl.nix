{
  stdenv,
  mkLLVM,
}:
mkLLVM rec {
  inherit stdenv;

  name = "pstl";
  targetDir = "runtimes";

  cmakeFlags = [
    "-DLLVM_ENABLE_RUNTIMES=${name}"
  ];
}
