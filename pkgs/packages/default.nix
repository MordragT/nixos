self: pkgs: let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
in {
  # astrofox = callPackage ./astrofox.nix { };
  byfl = callPackage ./byfl.nix {};
  comfyui-xpu = callPackage ./comfyui-xpu.nix {};
  dud = callPackage ./dud.nix {};
  ensembles = callPackage ./ensembles.nix {};
  epic-asset-manager = callPackage ./epic-asset-manager.nix {};
  llama-cpp-sycl = callPackage ./llama-cpp-sycl.nix {};
  lottieconv = callPackage ./lottieconv.nix {};
  my-vscode = callPackage ./my-vscode.nix {};
  oxen = callPackage ./oxen.nix {};
  spflashtool = callPackage ./spflashtool.nix {};
  tmfs = callPackage ./tmfs.nix {};
  vulkan-raytracing = callPackage ./vulkan-raytracing.nix {};
  webdesigner = callPackage ./webdesigner.nix {};
}
