{callPackage}: rec {
  ipex = callPackage ./ipex.nix {
    inherit torch;
  };
  torch = callPackage ./torch.nix {};
}
