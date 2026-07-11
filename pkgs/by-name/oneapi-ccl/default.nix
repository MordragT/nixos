{
  lib,
  intel-llvm,
  fetchFromGitHub,
  cmake,
  level-zero,
}:
# requires dpcpp compiler
intel-llvm.stdenv.mkDerivation (finalAttrs: {
  pname = "oneapi-ccl";
  version = "2022.0.0";

  src = fetchFromGitHub {
    owner = "uxlfoundation";
    repo = "oneCCL";
    rev = finalAttrs.version;
    hash = "sha256-VVI/vJMTi6d6is+ZuDWtsc+Zw32CA9RgLkGEc3VuWYE=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    level-zero
  ];

  # env.DPCPP_ROOT = intel-llvm.stdenv.cc.cc;

  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_FT=OFF" # functional tests
    "-DCCL_ENABLE_ZE=ON"
    "-DCOMPUTE_BACKEND=dpcpp"
    # DONECCL_USE_SYSTEM_LIBCCL=OFF
  ];

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  meta = {
    broken = true;
    changelog = "https://github.com/oneapi-src/oneCCL/releases/tag/${finalAttrs.version}";
    description = "oneAPI Collective Communications Library (oneCCL)";
    homepage = "https://01.org/oneCCL";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mordrag ];
    platforms = lib.platforms.all;
  };
})
# > CMake Error at src/cmake_install.cmake:185 (file):
# >   file INSTALL cannot find "/build/source/deps/mpi/var/empty/mpi/etc": No
# >   such file or directory.
# > Call Stack (most recent call first):
# >   cmake_install.cmake:131 (include)
# >
# >
