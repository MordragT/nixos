pySelf: pyPkgs:
let
  inherit (pySelf) callPackage;
  build-support = callPackage ./build-support.nix { };
in
{
  argbind = callPackage ./argbind { };

  bitsandbytes = callPackage ./bitsandbytes { };

  compel = callPackage ./compel { };

  datasets = pyPkgs.datasets.overrideAttrs (old: {
    postPatch = ''
      substituteInPlace src/datasets/utils/_dill.py \
        --replace-fail "0.3.8" "0.3.9"
    '';
  });

  descript-audio-codec = callPackage ./descript-audio-codec { };

  descript-audiotools = callPackage ./descript-audiotools { };

  dynamicprompts = callPackage ./dynamicprompts { };

  einops = pyPkgs.einops.overridePythonAttrs (a: {
    doCheck = false;
  });

  fastapi-events = callPackage ./fastapi-events { };

  invokeai = callPackage ./invokeai { };

  ipex = callPackage ./ipex {
    inherit (build-support) fetchipex;
    inherit (pySelf.pkgs) zstd;
  };

  marker-pdf = callPackage ./marker-pdf { };

  mediapipe = callPackage ./mediapipe { };

  nncf = callPackage ./nncf { };

  openvino-tokenizers = callPackage ./openvino-tokenizers {
    openvino-tokenizers-native = pySelf.pkgs.openvino-tokenizers;
  };

  optimum-intel = callPackage ./optimum-intel { };

  parler-tts = callPackage ./parler-tts { };

  pdftext = callPackage ./pdftext { };

  picklescan = callPackage ./picklescan { };

  pypatchmatch = callPackage ./pypatchmatch { };

  pystoi = callPackage ./pystoi { };

  randomname = callPackage ./randomname { };

  spandrel = callPackage ./spandrel { };

  surya-ocr = callPackage ./surya-ocr { };

  torch-bin = callPackage ./torch-bin {
    inherit (build-support) fetchtorch;
  };

  torch = pySelf.torch-bin;

  torch-stoi = callPackage ./torch-stoi { };

  torchaudio = callPackage ./torchaudio {
    inherit (build-support) fetchtorch;
  };

  torchvision = callPackage ./torchvision {
    inherit (build-support) fetchtorch;
  };

  triton-xpu = callPackage ./triton-xpu {
    inherit (build-support) fetchtorch;
  };
}
