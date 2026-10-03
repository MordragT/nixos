pySelf: pyPkgs:
let
  inherit (pySelf) callPackage;
  build-support = callPackage ./build-support.nix { };
in
{
  bitsandbytes = callPackage ./bitsandbytes { };

  compel = callPackage ./compel { };

  datasets = pyPkgs.datasets.overrideAttrs (old: {
    postPatch = ''
      substituteInPlace src/datasets/utils/_dill.py \
        --replace-fail "0.3.8" "0.3.9"
    '';
  });

  dynamicprompts = callPackage ./dynamicprompts { };

  einops = pyPkgs.einops.overridePythonAttrs (a: {
    doCheck = false;
  });

  fastapi-events = callPackage ./fastapi-events { };

  intel-oneapi = pyPkgs.toPythonModule pySelf.pkgs.intel-oneapi;

  invokeai = callPackage ./invokeai { };

  ipex = callPackage ./ipex {
    inherit (build-support) fetchipex;
    inherit (pySelf.pkgs) zstd;
  };

  marker-pdf = callPackage ./marker-pdf { };

  mediapipe = callPackage ./mediapipe { };

  nncf = callPackage ./nncf { };

  openvino-gpu = pyPkgs.openvino.override {
    openvino-native = pyPkgs.pkgs.openvino-gpu;
  };

  openvino-tokenizers-gpu = pyPkgs.openvino-tokenizers.override {
    openvino = pySelf.openvino-gpu;
    openvino-tokenizers-native = pyPkgs.pkgs.openvino-tokenizers-gpu;
  };

  openvino-genai-gpu = pyPkgs.openvino-genai.override {
    openvino-genai-native = pySelf.openvino-genai-gpu;
    openvino-tokenizers = pySelf.openvino-tokenizers-gpu;
  };

  optimum-intel = callPackage ./optimum-intel { };

  pdftext = callPackage ./pdftext { };

  picklescan = callPackage ./picklescan { };

  pypatchmatch = callPackage ./pypatchmatch { };

  pystoi = callPackage ./pystoi { };

  surya-ocr = callPackage ./surya-ocr { };

  torch-bin = callPackage ./torch-bin {
    inherit (build-support) fetchtorch;
  };

  torch = pySelf.torch-bin;

  torch-stoi = callPackage ./torch-stoi { };

  torchaudio = callPackage ./torchaudio {
    inherit (build-support) fetchtorch;
  };

  torchcodec = callPackage ./torchcodec {
    inherit (build-support) fetchtorch;
  };

  torchvision = callPackage ./torchvision {
    inherit (build-support) fetchtorch;
  };

  # Optimum Intel doesn't work with transformers 5.17.0, so we override it to 5.16.0
  transformers = pyPkgs.transformers.overrideAttrs (_: {
    version = "v5.16.1";

    src = pyPkgs.pkgs.fetchFromGitHub {
      owner = "huggingface";
      repo = "transformers";
      rev = "v5.16.1";
      hash = "sha256-VgBgaj4Qh2NVmJoqlrdb3hED/n1otIqDawXcALBpb2c=";
    };
  });

  triton-xpu = callPackage ./triton-xpu {
    inherit (build-support) fetchtorch;
  };
}
