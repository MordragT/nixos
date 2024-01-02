{
  autoPatchelfHook,
  addOpenGLRunpath,
  llvmPackages_17,
  fetchurl,
  level-zero,
  libz,
  libxml2,
  ncurses,
}:
llvmPackages_17.stdenv.mkDerivation rec {
  pname = "dpcpp-cpp-compiler";
  version = "nightly-2023-12-18";

  sourceRoot = ".";
  src = fetchurl {
    url = "https://github.com/intel/llvm/releases/download/${version}/sycl_linux.tar.gz";
    hash = "sha256-n/Y1rtEznKf7s7NBF5hUi2gKTimBBrIeEHS2XutDP2s=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    addOpenGLRunpath
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libamdhip64.so.5"
    "libamd_comgr.so.2"
    "libcuda.so.1"
    "libcupti.so.12"
    "libOpenCL.so.1"
  ];

  buildPhase = ''
    mkdir -p $out
    tar xf $src --directory=$out
  '';

  buildInputs = [
    llvmPackages_17.libcxx
    level-zero
    libz
    libxml2
    ncurses
  ];
}
