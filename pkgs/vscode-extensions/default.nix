self: pkgs: let
  buildSupport = pkgs.callPackage ./build-support.nix {};
  extensions = buildSupport.mkVsixPkgsFromList (builtins.fromJSON (builtins.readFile ./extensions.json));
in
  extensions
