{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  torch,
  optimum,
  transformers,
  datasets,
  sentencepiece,
  scipy,
  onnx,
  nncf,
  openvino,
  openvino-tokenizers,
  accelerate,
  ipex,
  diffusers,
}:
buildPythonPackage rec {
  pname = "optimum-intel";
  version = "1.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "optimum-intel";
    rev = "v${version}";
    hash = "sha256-gVm94yoV47nlGPtqPuU4ePzA1+1vnCCrRGoG2MrrFBA=";
  };
  build-system = [
    setuptools
  ];

  dependencies = [
    torch
    optimum
    transformers
    datasets
    sentencepiece
    scipy
    onnx
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
    neural-compressor = [
      #neural-compressor
      accelerate
    ];
    ipex = [
      ipex
      accelerate
    ];
    diffusers = [
      diffusers
    ];
  };

  pythonRelaxDeps = [
    "transformers"
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
