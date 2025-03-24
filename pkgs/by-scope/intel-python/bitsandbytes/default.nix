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
  version = "multi-backend-refactor-2025-03-18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bitsandbytes-foundation";
    repo = "bitsandbytes";
    rev = "8fe63259d21fff9387926aa86547414b67060536";
    hash = "";
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
