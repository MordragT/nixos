{
  cmake,
  fetchFromGitHub,
  lib,
  intel-sycl,
  opencl-headers,
  ocl-icd,
  oneapi-tbb,
}:
intel-sycl.stdenv.mkDerivation (finalAttrs: {
  pname = "oneapi-dnn";
  version = "3.6.2";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneDNN";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HEQVUnuVFd7/qgD19KLNF/qhVgah7Yhv8hLd5TmLE78=";
  };

  outputs = ["out" "dev" "doc"];

  nativeBuildInputs = [cmake];

  buildInputs = [
    ocl-icd
    opencl-headers
    oneapi-tbb
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
