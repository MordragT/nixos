_: pkgs:
let
  buildSupport = pkgs.callPackage ./build-support.nix { };
in
buildSupport.mkXpiAddonsFromList (builtins.fromJSON (builtins.readFile ./default.lock))
