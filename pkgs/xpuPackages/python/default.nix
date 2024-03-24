{
  pkgs,
  intel,
  oneapi,
}: rec {
  torch = pkgs.callPackage ./torch.nix {};
  ipex = pkgs.lib.callPackageWith (pkgs // pkgs.python3Packages // intel // oneapi) ./ipex.nix {inherit torch;};
}
