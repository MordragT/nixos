{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  torch,
  torchvision,
  safetensors,
  numpy,
  einops,
  typing-extensions,
}:
buildPythonPackage rec {
  pname = "spandrel";
  version = "0.4.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "chaiNNer-org";
    repo = "spandrel";
    rev = "v${version}";
    sha256 = "sha256-saRSosJ/pXmhLX5VqK3IBwT1yo14kD4nwNw0bCT2o5w=";
  };
  sourceRoot = "source/libs/spandrel";

  build-system = [
    setuptools
  ];

  buildInputs = [
    torch
    torchvision
    safetensors
    numpy
    einops
    typing-extensions
  ];

  pythonImportsCheck = ["spandrel"];
}
