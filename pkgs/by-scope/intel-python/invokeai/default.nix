{
  stdenv,
  coreutils,
  nodejs,
  pnpm,
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
  invisible-watermark,
  mediapipe,
  numpy,
  onnx,
  onnxruntime,
  opencv4,
  pytorch-lightning,
  safetensors,
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
  # version = "4.2.4";
  version = "unstable-2024-06-19";
  src = fetchFromGitHub {
    owner = "invoke-ai";
    repo = "InvokeAI";
    # rev = "v${version}";
    # hash = "sha256-eboJiYLqjfACA/4/efCYTbdDq44SivjtDR8P82UyKuQ=";
    rev = "a43d602f16b41c3023fa9556205af8173345f58b";
    hash = "sha256-v3VloLb/hHn+eOQb5KYVPc2DGCDVfavjXPFSrX09y7E=";
  };
  web = stdenv.mkDerivation rec {
    pname = "invokeai-web";
    inherit src version;

    sourceRoot = "source/invokeai/frontend/web";

    nativeBuildInputs = [
      nodejs
      pnpm.configHook
    ];

    pnpmDeps = pnpm.fetchDeps {
      inherit pname src version sourceRoot;
      hash = "sha256-zlJIq1msRZDllUmXiQKX13wvMRbkJ3Py3eJfzPxdVjc=";
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
      "pyreadline3"
      "opencv-python"
    ];
    pythonRelaxDeps = [
      "accelerate"
      # "clip_anytorch"
      # "compel"
      # "controlnet-aux"
      # "diffusers"
      "invisible-watermark"
      "mediapipe"
      "numpy"
      "onnx"
      "onnxruntime"
      # "opencv-python"
      "pytorch-lightning"
      "safetensors"
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
      invisible-watermark
      mediapipe
      numpy
      onnx
      onnxruntime
      opencv4
      pytorch-lightning
      safetensors
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
      ./pyproject.patch
      ./shutil-mode.patch
      ./xpu.patch
    ];

    postInstall = ''
      ln -s ${web} $out/${python.sitePackages}/invokeai/frontend/web/dist
    '';

    meta = {
      description = "Fancy Web UI for Stable Diffusion";
      homepage = "https://invoke-ai.github.io/InvokeAI/";
      mainProgram = "invokeai-web";
    };
  }
