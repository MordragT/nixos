{
  lib,
  intel-dpcpp,
  fetchFromGitHub,
  cmake,
  level-zero,
}:
# requires dpcpp compiler
intel-dpcpp.stdenv.mkDerivation (finalAttrs: {
  pname = "oneapi-ccl";
  version = "2021.15";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneCCL";
    rev = finalAttrs.version;
    hash = "sha256-ipmelJhbrj3fCzKjj4b/UsP5bxetjnTDJVQWZu0c6xA=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    level-zero
  ];

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  meta = {
    broken = true; # I don't know why a Install rule for mpi fails...
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

