{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  argbind,
  numpy,
  soundfile,
  importlib-resources,
  scipy,
  torch,
  julius,
  torchaudio,
  ffmpy,
  ipython,
  rich,
  matplotlib,
  librosa,
  pystoi,
  torch-stoi,
  flatten-dict,
  markdown2,
  randomname,
  protobuf,
  tensorboard,
  tqdm,
}:
buildPythonPackage rec {
  pname = "descript-audiotools";
  version = "0.7.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "descriptinc";
    repo = "audiotools";
    rev = version;
    hash = "sha256-mDReVnVgxb+qcTosUSNG3jp6QhaIWdcddyfK4xuyxCc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    argbind
    numpy
    soundfile
    # pyloudnorm
    importlib-resources
    scipy
    torch
    julius
    torchaudio
    ffmpy
    ipython
    rich
    matplotlib
    librosa
    pystoi
    torch-stoi
    flatten-dict
    markdown2
    randomname
    protobuf
    tensorboard
    tqdm
  ];

  pythonRemoveDeps = [
    "pyloudnorm"
  ];

  pythonRelaxDeps = [
    "protobuf"
  ];

  pythonImportsCheck = [ "audiotools" ];
}
