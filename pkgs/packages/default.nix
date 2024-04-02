self: pkgs: let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
in {
  # astrofox = callPackage ./astrofox.nix { };
  byfl = callPackage ./byfl.nix {};
  comfyui = callPackage ./comfyui.nix {};
  comfyui-nodes = callPackage ./comfyui-nodes.nix {};
  dud = callPackage ./dud.nix {};
  ensembles = callPackage ./ensembles.nix {};
  epic-asset-manager = callPackage ./epic-asset-manager.nix {};
  lottieconv = callPackage ./lottieconv.nix {};
  my-vscode = callPackage ./my-vscode.nix {};
  spflashtool = callPackage ./spflashtool.nix {};
  tmfs = callPackage ./tmfs.nix {};
  vulkan-raytracing = callPackage ./vulkan-raytracing.nix {};
  webdesigner = callPackage ./webdesigner.nix {};
}
