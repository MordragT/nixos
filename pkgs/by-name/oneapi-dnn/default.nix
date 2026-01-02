{
  cmake,
  fetchFromGitHub,
  lib,
  intel-sycl,
  opencl-headers,
  ocl-icd,
  level-zero,
  oneapi-tbb,
}:
intel-sycl.stdenv.mkDerivation (finalAttrs: {
  pname = "oneapi-dnn";
  version = "3.10.2";

  src = fetchFromGitHub {
    owner = "uxlfoundation";
    repo = "oneDNN";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/e57voLBNun/2koTF3sEb0Z/nDjCwq9NJVk7TaTSvMY=";
  };

  outputs = ["out" "dev" "doc"];

  nativeBuildInputs = [cmake];

  buildInputs = [
    level-zero
    ocl-icd
    opencl-headers
    oneapi-tbb
    intel-sycl.openmp
  ];

  cmakeFlags = [
    # "-DDNNL_LIBRARY_TYPE=STATIC"
    "-DDNNL_CPU_RUNTIME=SYCL"
    "-DDNNL_GPU_RUNTIME=SYCL"
    # "-DDNNL_BUILD_DOC=OFF"
    # "-DDNNL_BUILD_EXAMPLES=OFF"
    # "-DDNNL_BUILD_TESTS=OFF"
  ];

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  # postPatch = ''
  #   substituteInPlace src/CMakeLists.txt \
  #     --replace-fail 'if(DNNL_GPU_RUNTIME STREQUAL "OCL")' \
  #     'if(DNNL_GPU_RUNTIME STREQUAL "OCL" OR DNNL_GPU_RUNTIME STREQUAL "SYCL")'
  # '';

  # Fixup bad cmake paths
  postInstall = ''
    substituteInPlace $out/lib/cmake/dnnl/dnnl-config.cmake \
      --replace-fail "\''${PACKAGE_PREFIX_DIR}/" ""

    substituteInPlace $out/lib/cmake/dnnl/dnnl-targets.cmake \
      --replace-fail 'OpenCL::OpenCL' 'OpenCL'
  '';

  meta = {
    changelog = "https://github.com/oneapi-src/oneDNN/releases/tag/v${finalAttrs.version}";
    description = "oneAPI Deep Neural Network Library (oneDNN)";
    homepage = "https://01.org/oneDNN";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [bhipple];
    platforms = lib.platforms.all;
  };
})
