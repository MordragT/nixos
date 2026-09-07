{
  lib,
  fetchFromGitHub,
  autoAddDriverRunpath,
  intel-llvm,
  intel-graphics-compiler,
  intel-compute-runtime,
  cmake,
  ninja,
  pkg-config,
  oneapi-tbb,
  oneapi-dnn,
  oneapi-mkl,
  level-zero,
  ocl-icd,
  opencl-headers,
}:
let
  inherit (lib) cmakeBool cmakeFeature;
in
intel-llvm.stdenv.mkDerivation (finalAttrs: {
  pname = "ggml";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "ggml-org";
    repo = "ggml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QArqnQ5//Ft9Knm1Caqz68t4ikNQnk+O+OZUTfZlVCk=";
  };

  patches = [
    ./remove-trsm-batch.patch
  ];

  # nixpkgs' default `_FORTIFY_SOURCE=2/3` makes Clang emit `__memcpy_chk`
  # (the bounds-checked memcpy) instead of plain `__memcpy`. The Intel
  # Graphics Compiler (IGC) shipping in `intel-compute-runtime` does not
  # implement `__memcpy_chk` in its device-side runtime, so the JIT step
  # fails at first kernel dispatch.
  hardeningDisable = [ "all" ];

  # Disable automatic stripping completely
  dontStrip = true;

  env = {
    # libigc missing problems for ocloc (compute runtime)
    LD_LIBRARY_PATH = "${intel-graphics-compiler}/lib";
    NIX_CFLAGS_COMPILE = "-Xdevice-post-link --device-lib-dir=${intel-llvm.unwrapped.lib}/lib/dpcpp-7/sycl";
  };

  nativeBuildInputs = [
    autoAddDriverRunpath
    cmake
    ninja
    pkg-config
    intel-compute-runtime
  ];

  buildInputs = [
    oneapi-tbb
    oneapi-dnn
    oneapi-mkl
    level-zero
    ocl-icd
    opencl-headers
  ];

  cmakeFlags = [
    (cmakeFeature "CMAKE_CXX_FLAGS" "-w")
    (cmakeBool "GGML_NATIVE" false)
    (cmakeBool "BUILD_SHARED_LIBS" true)

    # Enable some CPU features targetting x86_64_v3 (Haswell and newer)
    (cmakeBool "GGML_SSE42" true)
    (cmakeBool "GGML_AVX" true)
    (cmakeBool "GGML_AVX2" true)
    (cmakeBool "GGML_FMA" true)
    (cmakeBool "GGML_F16C" true)
    (cmakeBool "GGML_BMI2" true)

    (cmakeBool "GGML_SYCL" true)
    (cmakeBool "GGML_SYCL_DNNL" true)
    (cmakeBool "GGML_SYCL_F16" true)
    (cmakeBool "GGML_SYCL_HOST_MEM_FALLBACK" true)
    # (cmakeFeature "GGML_SYCL_DEVICE_ARCH" "acm-g10")
  ];

  # The cmake package does not handle absolute CMAKE_INSTALL_LIBDIR and CMAKE_INSTALL_INCLUDEDIR
  # correctly.
  # Tracking: https://github.com/NixOS/nixpkgs/issues/144170
  postPatch = ''
    substituteInPlace ggml.pc.in \
      --replace-fail \
        "\''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@" \
        "@CMAKE_INSTALL_FULL_INCLUDEDIR@" \
      --replace-fail \
        "\''${prefix}/@CMAKE_INSTALL_LIBDIR@" \
        "@CMAKE_INSTALL_FULL_LIBDIR@"
  '';

  meta = {
    description = "Tensor library for machine learning";
    homepage = "https://github.com/ggml-org/ggml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mordrag ];
    platforms = lib.platforms.all;
  };
})
