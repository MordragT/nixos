self: pkgs: let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
in {
  byfl = callPackage ./byfl {};
  dud = callPackage ./dud {};
  ensembles = callPackage ./ensembles {};
  epic-asset-manager = callPackage ./epic-asset-manager {};

  intel-ccl = callPackage ./intel-ccl {};
  intel-dnnl = callPackage ./intel-dnnl {};
  intel-mkl = callPackage ./intel-mkl {};
  intel-mpi = callPackage ./intel-mpi {};
  intel-openmp = callPackage ./intel-openmp {};
  intel-tbb = callPackage ./intel-tbb {};
  intel-tcm = callPackage ./intel-tcm {};

  llama-cpp-sycl = callPackage ./llama-cpp-sycl {};
  lottieconv = callPackage ./lottieconv {};
  my-vscode = callPackage ./my-vscode {};
  ollama-sycl = callPackage ./ollama-sycl {};

  oneapi-ccl = callPackage ./oneapi-ccl {};
  oneapi-dal = callPackage ./oneapi-dal {};
  oneapi-dpl = callPackage ./oneapi-dpl {};
  oneapi-mkl = callPackage ./oneapi-mkl.nix {};

  opengothic = callPackage ./opengothic {};
  oxen = callPackage ./oxen {};
  proton-cachyos-bin = callPackage ./proton-cachyos-bin {};
  spflashtool = callPackage ./spflashtool {};
  tabby = callPackage ./tabby {};
  tmfs = callPackage ./tmfs {};

  unified-runtime = callPackage ./unified-runtime {};
  unified-memory-framework = callPackage ./unified-memory-framework {};

  vulkan-raytracing = callPackage ./vulkan-raytracing {};
  webdesigner = callPackage ./webdesigner {};
  wine-tkg = callPackage ./wine-tkg {};
  zen-browser-bin = callPackage ./zen-browser-bin {};
}
