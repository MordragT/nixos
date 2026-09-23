{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  torch,
  scipy,
}:
let
  pname = "bitsandbytes";
  version = "0.50.2";
  format = "wheel";
in
buildPythonPackage {
  inherit pname version format;

  src = fetchPypi {
    inherit pname version format;
    platform = "manylinux_2_24_x86_64";
    python = "py3";
    dist = "py3";
    sha256 = "sha256-VTSKmkohv9mc+MezL+Z7QDCuXCoFc44DwXR/ZfpuwoM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    scipy
    torch
  ];

  pythonImportsCheck = [ "bitsandbytes" ];

  meta = {
    description = "8-bit CUDA functions for PyTorch";
    homepage = "https://github.com/bitsandbytes-foundation/bitsandbytes";
    changelog = "https://github.com/bitsandbytes-foundation/bitsandbytes/releases/tag/continous-release_multi-backed-refactor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mordrag ];
  };
}
