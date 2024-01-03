{
  stdenv,
  fetchFromGitHub,
  addOpenGLRunpath,
  cmake,
  python3,
  ninja,
  level-zero,
  unified-runtime,
  libz,
  libxml2,
  ncurses,
}:
stdenv.mkDerivation rec {
  pname = "dpcpp-cpp-compiler";
  version = "nightly-2023-12-18";

  isClang = true;

  src = fetchFromGitHub {
    owner = "intel";
    repo = "llvm";
    rev = version;
    hash = "";
  };

  nativeBuildInputs = [
    cmake
    python3
    ninja
    addOpenGLRunpath
  ];

  buildInputs = [
    level-zero
    libz
    libxml2
    ncurses
    unified-runtime
  ];

  buildPhase = ''
    python3 $src/buildbot/configure.py \
      -t release \
      --shared-libs \
      --l0-headers ${level-zero}/include \
      --l0-loader ${level-zero}/lib \
      --cmake-opt="-DLLVM_INSTALL_UTILS=ON" \
      --cmake-opt="-DSYCL_PI_TESTS=OFF" \
      --cmake-opt="-DSYCL_PI_UR_USE_FETCH_CONTENT=OFF" \
      --cmake-opt="-DSYCL_PI_UR_SOURCE_DIR=${unified-runtime}"

    mkdir -p $out
    python3 $src/buildbot/compile.py -o $out
  '';
}
