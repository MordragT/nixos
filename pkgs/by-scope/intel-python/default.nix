self: pkgs: let
  build-support = self.callPackage ./build-support.nix {};
  callPackage = self.callPackage;
in {
  compel = callPackage ./compel {};
  controlnet-aux = callPackage ./controlnet-aux {};
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
