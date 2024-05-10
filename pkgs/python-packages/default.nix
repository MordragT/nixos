self: pkgs: let
  build-support = self.callPackage ./build-support.nix {};
  callPackage = self.callPackage;
in {
  torchWithXpu = callPackage ./torch.nix {
    inherit (build-support) fetchwheel;
  };
  torchvisionWithXpu = callPackage ./torchvision.nix {
    inherit (build-support) fetchwheel;
  };
  ipex = callPackage ./ipex.nix {
    inherit (build-support) fetchwheel;
  };
  mdns-beacon = callPackage ./mdns-beacon.nix {};
}
