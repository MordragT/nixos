{
  stdenv,
  coreutils,
  nodejs,
  pnpm,
  pnpmConfigHook,
  fetchPnpmDeps,
  buildPythonPackage,
  fetchFromGitHub,
  pythonRelaxDepsHook,
  setuptools,
  pip,
  python,
  accelerate,
  bitsandbytes,
  compel,
  diffusers,
  gguf,
  invisible-watermark,
  numpy,
  onnx,
  onnxruntime,
  opencv4,
  pytorch-lightning,
  safetensors,
  sentencepiece,
  spandrel,
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
}:
let
  version = "6.14.1";
  src = fetchFromGitHub {
    owner = "invoke-ai";
    repo = "InvokeAI";
    rev = "v${version}";
    hash = "sha256-yhlz8u2rsL2XRM3U0D2eFbJA1wz74mIgeTNRprx/KZY=";
  };
  web = stdenv.mkDerivation rec {
    pname = "invokeai-web";
    inherit src version;

    sourceRoot = "source/invokeai/frontend/web";

    nativeBuildInputs = [
      nodejs
      pnpm
      pnpmConfigHook
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit
        pname
        src
        version
        sourceRoot
        ;
      hash = "sha256-EBxUpRBq+9+evRUaqFTLaOypsZuImcqFKthlJiRAOms=";
      fetcherVersion = 4;
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
    "opencv-contrib-python"
    "mediapipe"
  ];
  pythonRelaxDeps = [
    "diffusers"
    "mediapipe"
    "numpy"
    "onnx"
    "onnxruntime"
    # "torch" # no idea why invokeai thinkgs torch is version 2.6.0
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
    bitsandbytes
    compel
    diffusers
    gguf
    invisible-watermark
    # mediapipe # not in python3.13
    numpy
    onnx
    onnxruntime
    opencv4
    pytorch-lightning
    safetensors
    sentencepiece
    spandrel
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

  # patches = [
  #   ./01-xpu-and-shutil.patch
  # ];

  postInstall = ''
    ln -s ${web} $out/${python.sitePackages}/invokeai/frontend/web/dist

    mkdir -p $out/share/icons/invokeai/scalable

    cp $out/${python.sitePackages}/invokeai/frontend/web/dist/assets/images/invoke-favicon.svg \
      $out/share/icons/invokeai/scalable/favicon.svg
  '';

  meta = {
    broken = true;
    description = "Fancy Web UI for Stable Diffusion";
    homepage = "https://invoke-ai.github.io/InvokeAI/";
    mainProgram = "invokeai-web";
  };
}
