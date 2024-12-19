{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  argbind,
  descript-audiotools,
  einops,
  numpy,
  torch,
  torchaudio,
  tqdm,
  tensorboard,
  numba,
  jupyterlab,
}:
buildPythonPackage rec {
  pname = "descript-audio-codec";
  version = "1.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "descriptinc";
    repo = "descript-audio-codec";
    rev = version;
    hash = "sha256-cABV+wyon211I2Gvhu0hn+Y1D/RiQ6pjxU7qYMN71BU=";
  };

  build-system = [setuptools];

  dependencies = [
    argbind
    descript-audiotools
    einops
    numpy
    torch
    torchaudio
    tqdm
    tensorboard
    numba
    jupyterlab
  ];

  pythonImportsCheck = ["dac"];
}
