_: prev:
let
  buildSupport = prev.callPackage ./build-support.nix { };
in
buildSupport.mkXpiAddonsFromList (builtins.fromJSON (builtins.readFile ./default.lock))
