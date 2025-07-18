{
  stdenv,
  coreutils,
  nodejs,
  pnpm_10,
  buildPythonPackage,
  fetchFromGitHub,
  pythonRelaxDepsHook,
  setuptools,
  pip,
  python,
  accelerate,
  compel,
  diffusers,
  gguf,
  invisible-watermark,
  mediapipe,
  numpy,
  onnx,
  onnxruntime,
  opencv4,
  pytorch-lightning,
  safetensors,
  sentencepiece,
  spandrel,
  ipex,
  torch,
  torchmetrics,
  torchsde,
  torchvision,
  transformers,
  fastapi-events,
  fastapi,
  huggingface-hub,
  pydantic-settings,
  python-socketio,
  uvicorn,
  blake3,
  deprecated,
  dnspython,
  dynamicprompts,
  einops,
  picklescan,
  pillow,
  prompt-toolkit,
  pypatchmatch,
  python-multipart,
  requests,
  semver,
}: let
  version = "6.0.2";
  src = fetchFromGitHub {
    owner = "invoke-ai";
    repo = "InvokeAI";
    rev = "v${version}";
    hash = "sha256-XmzjsBISi875aoMlya+E78yBGRVs73cy78C2hm6Exfo=";
  };
  web = stdenv.mkDerivation rec {
    pname = "invokeai-web";
    inherit src version;

    sourceRoot = "source/invokeai/frontend/web";

    nativeBuildInputs = [
      nodejs
      pnpm_10.configHook
    ];

    pnpmDeps = pnpm_10.fetchDeps {
      inherit pname src version sourceRoot;
      hash = "sha256-sjVQqSVxeljk5NO9NN0e7N1Vhft0QIA8+Pq9Nr+zAiw=";
      fetcherVersion = 2;
    };

    buildPhase = ''
      npx vite build
    '';

    installPhase = ''
      cp -r ./dist $out
    '';
  };
in
  buildPythonPackage {
    pname = "invokeai";
    inherit src version;
    format = "pyproject";

    nativeBuildInputs = [
      pythonRelaxDepsHook
    ];

    pythonRemoveDeps = [
      "bitsandbytes"
      "opencv-contrib-python"
    ];
    pythonRelaxDeps = [
      "diffusers"
      "mediapipe"
      "numpy"
      "onnx"
      "onnxruntime"
      "torch" # no idea why invokeai thinkgs torch is version 2.6.0
    ];

    build-system = [
      setuptools
      pip
    ];

    propagatedBuildInputs = [
      coreutils
    ];

    dependencies = [
      accelerate
      compel
      diffusers
      gguf
      invisible-watermark
      mediapipe
      numpy
      onnx
      onnxruntime
      opencv4
      pytorch-lightning
      safetensors
      sentencepiece
      spandrel
      ipex
      torch
      torchmetrics
      torchsde
      torchvision
      transformers

      fastapi-events
      fastapi
      huggingface-hub
      pydantic-settings
      python-socketio
      uvicorn

      blake3
      deprecated
      dnspython
      dynamicprompts
      einops # broken test
      picklescan
      pillow
      prompt-toolkit
      pypatchmatch
      python-multipart
      requests
      semver
    ];
    # optional-dependencies = {
    #   xformers = [xformers triton];
    #   onnx = [onnxruntime];
    #   onnx-cuda = [onnxrutnime-gpu];
    #   onnx-directml = [onnxruntime-directml];
    #   dist = [pip-tools pipdeptree twine];
    #   docs = [mkdocs-material mkdocs-git-revision-date-localized-plugin mkdocs-redirects mkdocstrings];
    #   dev = [jurigged pudb snakeviz gprof2dot];
    #   test = [ruff ruff-lsp mypy pre-commit pytest pytest-cov pytest-timeout pytest-datadir requests_testadapter httpx];
    # };

    patches = [
      ./01-xpu-and-shutil.patch
    ];

    postInstall = ''
      ln -s ${web} $out/${python.sitePackages}/invokeai/frontend/web/dist

      mkdir -p $out/share/icons/invokeai/scalable

      cp $out/${python.sitePackages}/invokeai/frontend/web/dist/assets/images/invoke-favicon.svg \
        $out/share/icons/invokeai/scalable/favicon.svg
    '';

    meta = {
      description = "Fancy Web UI for Stable Diffusion";
      homepage = "https://invoke-ai.github.io/InvokeAI/";
      mainProgram = "invokeai-web";
    };
  }
