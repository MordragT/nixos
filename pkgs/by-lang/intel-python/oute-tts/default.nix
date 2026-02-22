{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  scipy,
  einops,
  pyyaml,
  huggingface-hub,
  encodec,
  matplotlib,
  transformers,
  pytorch-lightning,
  tensorboardx,
  soundfile,
  numpy,
  jsonargparse,
  torchcrepe,
  librosa,
  pesq,
  inflect,
  loguru,
  polars,
  natsort,
  tqdm,
  requests,
  sounddevice,
  mecab-python3,
  unidic-lite,
  # uroman,
  openai-whisper,
}:
buildPythonPackage rec {
  pname = "oute-tts";
  version = "0.2.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "edwko";
    repo = "OuteTTS";
    rev = version;
    hash = "";
  };

  build-system = [ setuptools ];

  dependencies = [
    scipy
    einops
    pyyaml
    huggingface-hub
    encodec
    matplotlib
    transformers
    pytorch-lightning
    tensorboardx
    soundfile
    numpy
    jsonargparse
    torchcrepe
    librosa
    pesq
    inflect
    loguru
    polars
    natsort
    tqdm
    requests
    sounddevice
    mecab-python3
    unidic-lite
    # uroman
    openai-whisper
  ];

  pythonImportsCheck = [ "outetts" ];

  # missing uroman
  meta.broken = true;
}
