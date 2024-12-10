self: pkgs: let
  build-support = self.callPackage ./build-support.nix {};
  callPackage = self.callPackage;
in {
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
    inherit (build-support) fetchwheel;
  };
  mediapipe = callPackage ./mediapipe {};
  oneccl-bind-pt = callPackage ./oneccl-bind-pt {
    inherit (build-support) fetchwheel;
  };
  outlines = callPackage ./outlines {};
  outlines-core = callPackage ./outlines-core {};
  picklescan = callPackage ./picklescan {};
  pypatchmatch = callPackage ./pypatchmatch {};
  spandrel = callPackage ./spandrel {};
  torch = callPackage ./torch {
    inherit (build-support) fetchwheel;
  };
  torchaudio = callPackage ./torchaudio {
    inherit (build-support) fetchwheel;
  };
  torchvision = callPackage ./torchvision {
    inherit (build-support) fetchwheel;
  };
}
