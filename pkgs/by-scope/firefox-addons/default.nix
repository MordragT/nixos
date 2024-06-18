self: pkgs: let
  buildSupport = pkgs.callPackage ./build-support.nix {};
  addons = buildSupport.mkXpiAddonsFromList (builtins.fromJSON (builtins.readFile ./addons.json));
in
  addons
  // pkgs.nur.repos.rycee.firefox-addons
