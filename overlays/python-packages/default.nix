self: pkgs: rec {
  torchWithXpu = self.callPackage ./torch.nix {};
  ipex = self.callPackage ./ipex.nix {
    inherit torchWithXpu;
  };
}
