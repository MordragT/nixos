{
  lib,
  intel-sycl,
  fetchFromGitHub,
  cmake,
  level-zero,
}:
# requires dpcpp compiler
intel-sycl.stdenv.mkDerivation (finalAttrs: {
  pname = "oneapi-ccl";
  version = "2021.17";

  src = fetchFromGitHub {
    owner = "uxlfoundation";
    repo = "oneCCL";
    rev = finalAttrs.version;
    hash = "sha256-m+TQYtSs8qD2/5YzW/WRtl6Eg8nhGMVuSVi3Tz2ZQBQ=";
  };

  outputs = ["out" "dev"];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    level-zero
  ];

  # env.DPCPP_ROOT = intel-sycl.stdenv.cc.cc;

  cmakeFlags = [
    "-DBUILD_EXAMPLES=OFF"
    "-DBUILD_FT=OFF" # functional tests
    "-DCCL_ENABLE_ZE=ON"
    "-DCOMPUTE_BACKEND=dpcpp"
  ];

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  meta = {
    broken = true;
    changelog = "https://github.com/oneapi-src/oneCCL/releases/tag/${finalAttrs.version}";
    description = "oneAPI Collective Communications Library (oneCCL)";
    homepage = "https://01.org/oneCCL";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [mordrag];
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

