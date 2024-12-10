{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  setuptools,
  torch,
  scipy,
  ipex,
}:
buildPythonPackage {
  pname = "bitsandbytes";
  version = "multi-backend-refactor-2024-10-12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bitsandbytes-foundation";
    repo = "bitsandbytes";
    rev = "994833378a51a96db6a74ee8071654def47007b2";
    hash = "sha256-e9zGXsTkIppVI0zOqb+XzhtZklpqOv0iNd21HY0OI/M=";
  };

  nativeBuildInputs = [
    cmake
  ];

  build-system = [
    setuptools
  ];

  cmakeFlags = [
    (lib.cmakeFeature "COMPUTE_BACKEND" "cpu")
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "version=get_version_and_write_to_file()" 'version="0.45.0"'

    echo '__version__ = "0.45.0"' >> bitsandbytes/_version.py
  '';

  preBuild = ''
    make -j $NIX_BUILD_CORES
    cd .. # leave /build/source/build
  '';

  dependencies = [
    scipy
    torch
    ipex
  ];

  doCheck = false; # tests require CUDA and also GPU access

  pythonImportsCheck = ["bitsandbytes"];

  meta = {
    description = "8-bit CUDA functions for PyTorch";
    homepage = "https://github.com/bitsandbytes-foundation/bitsandbytes";
    changelog = "https://github.com/bitsandbytes-foundation/bitsandbytes/releases/tag/continous-release_multi-backed-refactor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [mordrag];
  };
}
