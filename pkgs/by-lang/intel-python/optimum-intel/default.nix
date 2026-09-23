{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  torch,
  torchvision,
  optimum,
  transformers,
  datasets,
  sentencepiece,
  scipy,
  onnx,
  nncf,
  openvino,
  openvino-tokenizers,
  diffusers,
}:
let
  version = "2.2.0";
in
buildPythonPackage {
  pname = "optimum-intel";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "optimum-intel";
    rev = "v${version}";
    hash = "sha256-d7kLE0xjgtkhVvT7St/at3RSnWPvZjBl9AyD1sQ7nq8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    torch
    torchvision
    optimum
    transformers
    datasets
    sentencepiece
    scipy
    onnx
    nncf
    openvino
    openvino-tokenizers
  ];

  optional-dependencies = {
    nncf = [
      nncf
    ];
    openvino = [
      nncf
      openvino
      openvino-tokenizers
    ];
    diffusers = [
      diffusers
    ];
  };

  pythonRelaxDeps = [
    "transformers"
    "optimum"
    "huggingface-hub"
  ];

  # These somehow fail although provided
  pythonRemoveDeps = [
    "openvino"
    "openvino-tokenizers"
  ];

  # collision with optimum-cli and does import that only anyways
  postInstall = ''
    rm -r $out/bin
  '';

  doCheck = false; # tests require CUDA and also GPU access

  pythonImportsCheck = [
    "optimum.intel"
    "optimum.exporters"
  ];

  meta = {
    description = "Accelerate inference with Intel optimization tools";
    homepage = "https://github.com/huggingface/optimum-intel/tree/main";
    changelog = "https://github.com/huggingface/optimum-intel/tree/main/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mordrag ];
  };
}
