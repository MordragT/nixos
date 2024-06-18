{
  stdenv,
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
  version = "4.2.4";
  src = fetchFromGitHub {
    owner = "invoke-ai";
    repo = "InvokeAI";
    rev = "v${version}";
    hash = "sha256-eboJiYLqjfACA/4/efCYTbdDq44SivjtDR8P82UyKuQ=";
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

    patchPhase = ''
      substituteInPlace ./pyproject.toml \
        --replace-warn 'setuptools~=65.5' 'setuptools' \
        --replace-warn 'pip~=22.3' 'pip'

      substituteInPlace ./invokeai/app/api_app.py \
        --replace-fail 'import torch' $'import torch\nimport intel_extension_for_pytorch as ipex'

      # Add subprocess to the imports
      # shutil.copytree will inherit the permissions of files in the /nix/store
      # which are read only, so we subprocess.call cp instead and tell it not to
      # preserve the mode
      substituteInPlace ./invokeai/app/services/config/config_default.py \
        --replace-fail 'import shutil' $'import shutil\nimport subprocess' \
        --replace-fail "shutil.copytree(configs_src, config.legacy_conf_path, dirs_exist_ok=True)" \
          "subprocess.call('cp -r -n --no-preserve=mode {src}/* {dest}'.format(src=configs_src, dest=config.legacy_conf_path), shell=True)" \
        --replace-fail 'DEVICE = Literal["auto", "cpu", "cuda", "cuda:1", "mps"]' \
          'DEVICE = Literal["auto", "cpu", "cuda", "cuda:1", "mps", "xpu"]'

      substituteInPlace ./invokeai/app/invocations/__init__.py \
        --replace-fail 'import shutil' $'import shutil\nimport subprocess' \
        --replace-fail 'shutil.copy(Path(__file__).parent / "custom_nodes/init.py", custom_nodes_init_path)' \
          "subprocess.call('cp --no-preserve=mode {src} {dest}'.format(src=Path(__file__).parent / 'custom_nodes/init.py', dest=custom_nodes_init_path), shell=True)" \
        --replace-fail 'shutil.copy(Path(__file__).parent / "custom_nodes/README.md", custom_nodes_readme_path)' \
          "subprocess.call('cp --no-preserve=mode {src} {dest}'.format(src=Path(__file__).parent / 'custom_nodes/README.md', dest=custom_nodes_readme_path), shell=True)"
    '';

    postInstall = ''
      ln -s ${web} $out/${python.sitePackages}/invokeai/frontend/web/dist
    '';

    meta = {
      description = "Fancy Web UI for Stable Diffusion";
      homepage = "https://invoke-ai.github.io/InvokeAI/";
      mainProgram = "invokeai-web";
    };
  }
