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
  dynamicprompts = callPackage ./dynamicprompts {};
  easing-functions = callPackage ./easing-functions {};
  facexlib = callPackage ./facexlib {};
  fastapi-events = callPackage ./fastapi-events {};
  invokeai = callPackage ./invokeai {};

  ipex = callPackage ./ipex {
    inherit (build-support) fetchipex;
  };
  torch-ipex = callPackage ./torch-ipex {
    inherit (build-support) fetchipex;
  };
  torchaudio-ipex = callPackage ./torchaudio-ipex {
    inherit (build-support) fetchipex;
  };
  torchvision-ipex = callPackage ./torchvision-ipex {
    inherit (build-support) fetchipex;
  };
  oneccl-bind-pt = callPackage ./oneccl-bind-pt {
    inherit (build-support) fetchipex;
  };

  mediapipe = callPackage ./mediapipe {};
  nncf = callPackage ./nncf {};
  openvino-tokenizers = callPackage ./openvino-tokenizers {
    openvino-tokenizers-native = self.pkgs.openvino-tokenizers;
  };
  optimum-intel = callPackage ./optimum-intel {};
  outlines = callPackage ./outlines {};
  outlines-core = callPackage ./outlines-core {};
  picklescan = callPackage ./picklescan {};
  pypatchmatch = callPackage ./pypatchmatch {};
  spandrel = callPackage ./spandrel {};

  torch = callPackage ./torch {
    inherit (build-support) fetchtorch;
  };
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
