{
  mkLLVM,
  stdenv,
  llvm,
}:
mkLLVM rec {
  inherit stdenv;

  name = "libc";
  targetDir = "runtimes";

  env.NIX_CFLAGS_COMPILE = "-Wno-implicit-float-size-conversion -Wno-macro-redefined";

  cmakeFlags = [
    "-DLLVM_ENABLE_RUNTIMES=${name}"
    "-DLLVM_INCLUDE_TESTS=OFF"
    # "-DLLVM_LIBC_FULL_BUILD=ON"
    "-DLLVM_LIBC_GPU_BUILD=ON"
    "-DLIBC_INCLUDE_BENCHMARKS=OFF"
    "-DLIBC_INCLUDE_DOCS=OFF"
  ];

  extraBuildInputs = [
    llvm
  ];
}
