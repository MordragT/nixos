{
  stdenv,
  coreutils,
  nodejs,
  pnpm_8,
  buildPythonPackage,
  fetchFromGitHub,
  pythonRelaxDepsHook,
  setuptools,
  pip,
  python,
  accelerate,
  clip-anytorch,
  compel,
  controlnet-aux,
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
  timm,
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
  albumentations,
  blake3,
  click,
  datasets,
  deprecated,
  dnspython,
  dynamicprompts,
  easing-functions,
  einops,
  facexlib,
  matplotlib,
  npyscreen,
  omegaconf,
  picklescan,
  pillow,
  prompt-toolkit,
  pympler,
  pypatchmatch,
  pyperclip,
  python-multipart,
  requests,
  rich,
  scikit-image,
  semver,
  send2trash,
  test-tube,
}: let
  version = "5.4.2";
  src = fetchFromGitHub {
    owner = "invoke-ai";
    repo = "InvokeAI";
    rev = "v${version}";
    hash = "sha256-uZ94eh9i0WnWjJG3a00uqMmYWFkb6vF6pYo/zJq7ZOE=";
  };
  web = stdenv.mkDerivation rec {
    pname = "invokeai-web";
    inherit src version;

    sourceRoot = "source/invokeai/frontend/web";

    nativeBuildInputs = [
      nodejs
      pnpm_8.configHook
    ];

    pnpmDeps = pnpm_8.fetchDeps {
      inherit pname src version sourceRoot;
      hash = "sha256-nsBB911Hk1Ef7HO8MpchHqSWIpfq0wlhv3bOa1Rdiww=";
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

    # own custom wrapping with ipexrun
    # dontWrapPythonPrograms = true;

    pythonRemoveDeps = [
      "bitsandbytes"
      "pyreadline3"
      "opencv-python"
    ];
    pythonRelaxDeps = [
      "accelerate"
      # "clip_anytorch"
      # "compel"
      # "controlnet-aux"
      "diffusers"
      "gguf"
      "invisible-watermark"
      "mediapipe"
      "numpy"
      "onnx"
      "onnxruntime"
      # "opencv-python"
      "pytorch-lightning"
      "safetensors"
      # "sentencepiece"
      # "spandrel"
      "timm"
      "torch"
      "torchmetrics"
      "torchsde"
      "torchvision"
      "transformers"

      # "fastapi-events"
      "fastapi"
      "huggingface-hub"
      "pydantic-settings"
      "python-socketio"
      "uvicorn"

      "pydantic"
      "dnspython"
      "requests"
      "scikit-image"
      "test-tube"
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
      clip-anytorch
      compel
      controlnet-aux
      diffusers.optional-dependencies.torch
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
      timm
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

      albumentations
      blake3
      click
      datasets
      deprecated
      dnspython
      dynamicprompts
      easing-functions
      einops
      facexlib
      matplotlib
      npyscreen
      omegaconf
      picklescan
      pillow
      prompt-toolkit
      pympler
      pypatchmatch
      pyperclip
      python-multipart
      requests
      rich
      scikit-image
      semver
      send2trash
      test-tube
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
      ./shutil-mode.patch
      ./xpu.patch
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
