{
  stdenv,
  mkLLVM,
}:
mkLLVM rec {
  inherit stdenv;

  name = "compiler-rt";
  targetDir = "runtimes";

  cmakeFlags = [
    "-DLLVM_ENABLE_RUNTIMES=${name}"
  ];
}
