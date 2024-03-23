{
  stdenvNoCC,
  autoPatchelfHook,
  addOpenGLRunpath,
  llvmPackages,
  fetchurl,
  level-zero,
  libz,
  libxml2,
  ocl-icd,
  ncurses,
}:
stdenvNoCC.mkDerivation rec {
  pname = "llvm-bin";
  version = "nightly-2024-03-22";

  isClang = true;

  sourceRoot = ".";
  src = fetchurl {
    url = "https://github.com/intel/llvm/releases/download/${version}/sycl_linux.tar.gz";
    hash = "sha256-f7HMNTOZ6ElbsI6YTDnzjufbQ/VAfkSdys7T49vMbrk=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    addOpenGLRunpath
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libamdhip64.so.6"
    "libamd_comgr.so.2"
    "libcuda.so.1"
    "libcupti.so.12"
    # "libOpenCL.so.1"
  ];

  buildPhase = ''
    mkdir -p $out
    tar xf $src --directory=$out
  '';

  buildInputs = [
    llvmPackages.libcxx
    level-zero
    ocl-icd
    libz
    libxml2
    ncurses
  ];
}
