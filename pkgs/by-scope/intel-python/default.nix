self: pkgs: let
  build-support = self.callPackage ./build-support.nix {};
  callPackage = self.callPackage;
in {
  aniposelib = callPackage ./aniposelib {};

  argbind = callPackage ./argbind {};

  bitsandbytes = callPackage ./bitsandbytes {};

  compel = callPackage ./compel {};

  controlnet-aux = callPackage ./controlnet-aux {};

  deffcode = callPackage ./deffcode {};

  datasets = pkgs.datasets.overrideAttrs (old: {
    postPatch = ''
      substituteInPlace src/datasets/utils/_dill.py \
        --replace-fail "0.3.8" "0.3.9"
    '';
  });

  descript-audio-codec = callPackage ./descript-audio-codec {};

  descript-audiotools = callPackage ./descript-audiotools {};

  dynamicprompts = callPackage ./dynamicprompts {};

  easing-functions = callPackage ./easing-functions {};

  einops = pkgs.einops.overridePythonAttrs (a: {doCheck = false;});

  facexlib = callPackage ./facexlib {};

  fastapi-events = callPackage ./fastapi-events {};

  freemocap = callPackage ./freemocap {};

  freemocap-blender-addon = callPackage ./freemocap-blender-addon {};

  invokeai = callPackage ./invokeai {};

  ipex = callPackage ./ipex {
    inherit (build-support) fetchipex;
    inherit (self.pkgs) zstd;
  };

  mediapipe = callPackage ./mediapipe {};

  nncf = callPackage ./nncf {};

  oneccl-bind-pt = callPackage ./oneccl-bind-pt {
    inherit (build-support) fetchipex;
  };

  openvino-tokenizers = callPackage ./openvino-tokenizers {
    openvino-tokenizers-native = self.pkgs.openvino-tokenizers;
  };

  optimum-intel = callPackage ./optimum-intel {};

  oute-tts = callPackage ./oute-tts {};

  parler-tts = callPackage ./parler-tts {};

  picklescan = callPackage ./picklescan {};

  pypatchmatch = callPackage ./pypatchmatch {};

  pystoi = callPackage ./pystoi {};

  randomname = callPackage ./randomname {};

  skelly-synchronize = callPackage ./skelly-synchronize {};

  skelly-viewer = callPackage ./skelly-viewer {};

  skellycam = callPackage ./skellycam {};

  skellyforge = callPackage ./skellyforge {};

  skellytracker = callPackage ./skellytracker {};

  spandrel = callPackage ./spandrel {};

  torch = callPackage ./torch {
    inherit (build-support) fetchtorch;
  };

  torch-stoi = callPackage ./torch-stoi {};

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
