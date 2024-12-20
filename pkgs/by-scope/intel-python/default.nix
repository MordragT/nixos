self: pkgs: let
  build-support = self.callPackage ./build-support.nix {};
  callPackage = self.callPackage;
in {
  accelerate = callPackage ({fetchFromGitHub}:
    pkgs.accelerate.overrideAttrs (_: {
      src = fetchFromGitHub {
        owner = "dvrogozh";
        repo = "accelerate";
        rev = "623a9e126c8eaa9cfaeedb4069362baf032a7268";
        hash = "sha256-M5tTN3+ESMWnxl4fo4bmwDmP9GO22g2oTmm6Y/bXRbI=";
      };
    })) {};

  airportsdata = callPackage ./airportsdata {};

  argbind = callPackage ./argbind {};

  bitsandbytes = callPackage ./bitsandbytes {};

  compel = callPackage ./compel {};

  controlnet-aux = callPackage ./controlnet-aux {};

  datasets = pkgs.datasets.overrideAttrs (old: {
    postPatch =
      ''
        substituteInPlace src/datasets/utils/_dill.py \
          --replace-fail "0.3.8" "0.3.9"
      ''
      + old.postPatch;
  });

  descript-audio-codec = callPackage ./descript-audio-codec {};

  descript-audiotools = callPackage ./descript-audiotools {};

  dynamicprompts = callPackage ./dynamicprompts {};

  easing-functions = callPackage ./easing-functions {};

  facexlib = callPackage ./facexlib {};

  fastapi-events = callPackage ./fastapi-events {};

  invokeai = callPackage ./invokeai {};

  ipex = callPackage ./ipex {
    inherit (build-support) fetchipex;
  };

  mediapipe = callPackage ./mediapipe {};

  moviepy = callPackage ./moviepy {};

  nncf = callPackage ./nncf {};

  oneccl-bind-pt = callPackage ./oneccl-bind-pt {
    inherit (build-support) fetchipex;
  };

  openvino-tokenizers = callPackage ./openvino-tokenizers {
    openvino-tokenizers-native = self.pkgs.openvino-tokenizers;
  };

  optimum-intel = callPackage ./optimum-intel {};

  oute-tts = callPackage ./oute-tts {};

  outlines = callPackage ./outlines {};

  outlines-core = callPackage ./outlines-core {};

  parler-tts = callPackage ./parler-tts {};

  picklescan = callPackage ./picklescan {};

  pypatchmatch = callPackage ./pypatchmatch {};

  randomname = callPackage ./randomname {};

  spandrel = callPackage ./spandrel {};

  torch = self.torch-ipex;

  torch-ipex = callPackage ./torch-ipex {
    inherit (build-support) fetchipex;
    zstd-native = self.pkgs.zstd;
  };

  torch-nightly = callPackage ./torch-nightly {
    inherit (build-support) fetchtorch;
  };

  torchaudio = self.torchaudio-ipex;

  torchaudio-ipex = callPackage ./torchaudio-ipex {
    inherit (build-support) fetchipex;
  };

  torchaudio-nightly = callPackage ./torchaudio-nightly {
    inherit (build-support) fetchtorch;
  };

  torchvision = self.torchvision-ipex;

  torchvision-ipex = callPackage ./torchvision-ipex {
    inherit (build-support) fetchipex;
  };

  torchvision-nightly = callPackage ./torchvision-nightly {
    inherit (build-support) fetchtorch;
  };

  triton-xpu = callPackage ./triton-xpu {
    inherit (build-support) fetchtorch;
  };
}
