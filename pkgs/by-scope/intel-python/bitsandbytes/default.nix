{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  setuptools,
  setuptools-scm,
  torch,
  scipy,
  ipex,
}:
buildPythonPackage rec {
  pname = "bitsandbytes";
  version = "0.48.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bitsandbytes-foundation";
    repo = "bitsandbytes";
    rev = version;
    hash = "";
  };

  nativeBuildInputs = [
    cmake
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  cmakeFlags = [
    (lib.cmakeFeature "COMPUTE_BACKEND" "xpu")
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "version=write_version_file(VERSION)" "version=VERSION"

    echo '__version__ = "1.0.0"' >> bitsandbytes/_version.py
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
