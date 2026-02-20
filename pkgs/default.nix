{
  perSystem =
    { pkgs, ... }:
    let
      packages = import ./overlay.nix packages pkgs;
    in
    {
      inherit packages;
    };

  flake.overlays.default = import ./overlay.nix;
}
