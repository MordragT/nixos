self: pkgs: let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
in {
  byfl = callPackage ./byfl {};
  cosmic-ext-alternative-startup = callPackage ./cosmic-ext-alternative-startup {};
  cosmic-ext-niri = callPackage ./cosmic-ext-niri {};
  dud = callPackage ./dud {};
  ensembles = callPackage ./ensembles {};
  epic-asset-manager = callPackage ./epic-asset-manager {};

  intel-ccl = callPackage ./intel-ccl {};
  intel-dnnl = callPackage ./intel-dnnl {};
  intel-metrics = callPackage ./intel-metrics {};
  intel-mkl = callPackage ./intel-mkl {};
  intel-mpi = callPackage ./intel-mpi {};
  intel-openmp = callPackage ./intel-openmp {};
  intel-tbb = callPackage ./intel-tbb {};
  intel-tcm = callPackage ./intel-tcm {};

  linux-msft-wsl = callPackage ./linux-msft-wsl {};
  llama-cpp-sycl = callPackage ./llama-cpp-sycl {};
  lottieconv = callPackage ./lottieconv {};
  mtk-client = callPackage ./mtk-client {};
  ollama-sycl = callPackage ./ollama-sycl {};

  oneapi-ccl = callPackage ./oneapi-ccl {};
  oneapi-dal = callPackage ./oneapi-dal {};
  oneapi-dnn = callPackage ./oneapi-dnn {};
  oneapi-dpl = callPackage ./oneapi-dpl {};
  oneapi-math = callPackage ./oneapi-math {};
  oneapi-tbb = callPackage ./oneapi-tbb {};

  opengothic = callPackage ./opengothic {};
  openvino-tokenizers = callPackage ./openvino-tokenizers {};
  oxen = callPackage ./oxen {};
  proton-cachyos-bin = callPackage ./proton-cachyos-bin {};
  spflashtool = callPackage ./spflashtool {};
  spflashtool-v5 = callPackage ./spflashtool-v5 {};
  tabby = callPackage ./tabby {};
  tmfs = callPackage ./tmfs {};

  unified-runtime = callPackage ./unified-runtime {};
  unified-memory-framework = callPackage ./unified-memory-framework {};

  vulkan-raytracing = callPackage ./vulkan-raytracing {};
  wine-tkg = callPackage ./wine-tkg {};
  zen-browser-bin = callPackage ./zen-browser-bin {};
}
