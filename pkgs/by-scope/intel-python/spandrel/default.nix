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
  version = "0.3.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "chaiNNer-org";
    repo = "spandrel";
    rev = "v${version}";
    sha256 = "sha256-cwY8gFcaHkyYI0y31WK76FKeq0jhYdbArHhh8Q6c3DE=";
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
