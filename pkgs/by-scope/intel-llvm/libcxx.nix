{
  stdenv,
  mkLLVM,
}:
mkLLVM {
  inherit stdenv;

  name = "libcxx";
  targetDir = "runtimes";

  cmakeFlags = [
    "-DLLVM_ENABLE_RUNTIMES=libcxx;libcxxabi;libunwind;"
  ];
}
