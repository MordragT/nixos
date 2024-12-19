{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  transformers,
  torch,
  sentencepiece,
  descript-audiotools,
  descript-audio-codec,
}:
buildPythonPackage {
  pname = "parler-tts";
  version = "unstable-2024-12-02";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "parler-tts";
    rev = "77d10df6d230fbdedcf92fc561182701ae6710ca";
    hash = "sha256-XZJ9AmQKHp+kILkSZlHUxEdIG1xXyv5NqhCPo5EN3UU=";
  };

  build-system = [setuptools];

  dependencies = [
    transformers
    torch
    sentencepiece
    descript-audiotools
    descript-audio-codec
  ];

  pythonRelaxDeps = [
    "transformers"
  ];

  pythonImportsCheck = ["parler_tts"];
}
