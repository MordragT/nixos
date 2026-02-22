_: prev:
let
  buildSupport = prev.callPackage ./build-support.nix { };
  extensions = buildSupport.mkVsixPkgsFromList (builtins.fromJSON (builtins.readFile ./default.lock));
in
prev.lib.recursiveUpdate prev.vscode-extensions extensions
