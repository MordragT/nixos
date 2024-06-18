self: pkgs: let
  build-support = self.callPackage ./build-support.nix {};
  callPackage = self.callPackage;
in {
  blake3 = callPackage ./blake3.nix {};
  compel = callPackage ./compel.nix {};
  controlnet-aux = callPackage ./controlnet-aux.nix {};
  diffusers = callPackage ./diffusers.nix {};
  fastapi-events = callPackage ./fastapi-events.nix {};
  dynamicprompts = callPackage ./dynamicprompts.nix {};
  mediapipe = callPackage ./mediapipe.nix {};
  easing-functions = callPackage ./easing-functions.nix {};
  facexlib = callPackage ./facexlib.nix {};
  picklescan = callPackage ./picklescan.nix {};
  pypatchmatch = callPackage ./pypatchmatch.nix {};

  invokeai = callPackage ./invokeai.nix {};
  ipex = callPackage ./ipex.nix {
    inherit (build-support) fetchwheel;
  };
  oneccl-bind-pt = callPackage ./oneccl-bind-pt.nix {
    inherit (build-support) fetchwheel;
  };
  spandrel = callPackage ./spandrel.nix {};
  torch = callPackage ./torch.nix {
    inherit (build-support) fetchwheel;
  };
  torchaudio = callPackage ./torchaudio.nix {
    inherit (build-support) fetchwheel;
  };
  torchvision = callPackage ./torchvision.nix {
    inherit (build-support) fetchwheel;
  };
}
