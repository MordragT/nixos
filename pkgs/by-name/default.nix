self: pkgs: let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
in {
  # astrofox = callPackage ./astrofox { };
  byfl = callPackage ./byfl {};
  comfyui-xpu = callPackage ./comfyui-xpu {};
  dud = callPackage ./dud {};
  ensembles = callPackage ./ensembles {};
  epic-asset-manager = callPackage ./epic-asset-manager {};
  llama-cpp-sycl = callPackage ./llama-cpp-sycl {};
  lottieconv = callPackage ./lottieconv {};
  my-vscode = callPackage ./my-vscode {};
  oxen = callPackage ./oxen {};
  spflashtool = callPackage ./spflashtool {};
  tmfs = callPackage ./tmfs {};
  vulkan-raytracing = callPackage ./vulkan-raytracing {};
  webdesigner = callPackage ./webdesigner {};
}
