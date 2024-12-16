{
  src,
  version,
  intel-sycl,
  cmake,
  pkg-config,
  python3,
  autoAddDriverRunpath,
  level-zero,
  ocl-icd,
  spdlog,
}:
intel-sycl.stdenv.mkDerivation {
  pname = "pti-gpu-sdk";
  inherit src version;

  sourceRoot = "source/sdk";

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    autoAddDriverRunpath
  ];

  buildInputs = [
    level-zero
    ocl-icd
    spdlog
  ];

  cmakeFlags = [
    "-DPTI_BUILD_TESTING=OFF"
    "-DPTI_BUILD_SAMPLES=OFF"
    "-DPTI_ENABLE_LOGGING=ON"
    "-DXpti_INCLUDE_DIR=${intel-sycl.llvm.dev}/include/xpti"
    "-DXpti_STATIC_LIBRARY=${intel-sycl.llvm.lib}/lib/libxpti.a"
    "-DXpti_SHARED_LIBRARY=${intel-sycl.llvm.lib}/lib/libxptifw.so"
  ];
}
