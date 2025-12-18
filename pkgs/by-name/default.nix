self: pkgs: let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
in {
  byfl = callPackage ./byfl {};
  chatgpt = callPackage ./chatgpt {};

  cosmic-ext-accounts = callPackage ./cosmic-ext-accounts {};
  cosmic-ext-alternative-startup = callPackage ./cosmic-ext-alternative-startup {};
  cosmic-ext-applet-clipboard-manager = callPackage ./cosmic-ext-applet-clipboard-manager {};
  cosmic-ext-applet-connect = callPackage ./cosmic-ext-applet-connect {};
  cosmic-ext-applet-emoji-selector = callPackage ./cosmic-ext-applet-emoji-selector {};
  cosmic-ext-applet-gamemode-status = callPackage ./cosmic-ext-applet-gamemode-status {};
  cosmic-ext-applet-git-work = callPackage ./cosmic-ext-applet-git-work {};
  cosmic-ext-applet-logomenu = callPackage ./cosmic-ext-applet-logomenu {};
  cosmic-ext-applet-minimon = callPackage ./cosmic-ext-applet-minimon {};
  cosmic-ext-applet-music-player = callPackage ./cosmic-ext-applet-music-player {};
  cosmic-ext-applet-privacy-indicator = callPackage ./cosmic-ext-applet-privacy-indicator {};
  cosmic-ext-applet-system-monitor = callPackage ./cosmic-ext-applet-system-monitor {};
  cosmic-ext-applet-tailscale = callPackage ./cosmic-ext-applet-tailscale {};
  cosmic-ext-applet-weather = callPackage ./cosmic-ext-applet-weather {};
  cosmic-ext-bg-theme = callPackage ./cosmic-ext-bg-theme {};
  cosmic-ext-calendar = callPackage ./cosmic-ext-calendar {};
  cosmic-ext-niri = callPackage ./cosmic-ext-niri {};

  cutecosmic = callPackage ./cutecosmic {};
  dud = callPackage ./dud {};
  emhash = callPackage ./emhash {};
  ensembles = callPackage ./ensembles {};
  epic-asset-manager = callPackage ./epic-asset-manager {};
  fan-control = callPackage ./fan-control {};

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
  oneapi-math-sycl-blas = callPackage ./oneapi-math-sycl-blas {};
  oneapi-tbb = callPackage ./oneapi-tbb {};

  open-plc-utils = callPackage ./open-plc-utils {};
  opengothic = callPackage ./opengothic {};
  openvino-tokenizers = callPackage ./openvino-tokenizers {};
  oxen = callPackage ./oxen {};
  pla-util = callPackage ./pla-util {};
  proton-cachyos-bin = callPackage ./proton-cachyos-bin {};

  spflashtool = callPackage ./spflashtool {};
  spflashtool-v5 = callPackage ./spflashtool-v5 {};
  starrydex = callPackage ./starrydex {};
  teamfight-tactics = callPackage ./teamfight-tactics {};
  tmfs = callPackage ./tmfs {};

  unified-memory-framework = callPackage ./unified-memory-framework {};
  vc-intrinsics = callPackage ./vc-intrinsics {};
  vulkan-raytracing = callPackage ./vulkan-raytracing {};
  wine-tkg = callPackage ./wine-tkg {};
  zen-browser-bin = callPackage ./zen-browser-bin {};
}
