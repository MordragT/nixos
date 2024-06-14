self: pkgs: let
  build-support = self.callPackage ./build-support.nix {};
  callPackage = self.callPackage;
in {
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
