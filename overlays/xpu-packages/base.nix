{
  stdenv,
  name,
  cmakeFlags,
  targetDir,
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
  perl,
  libz,
  libxml2,
  ncurses,
}:
stdenv.mkDerivation rec {
  inherit cmakeFlags;

  pname = name;
  version = "nightly-2024-01-24";
  src = fetchFromGitHub {
    owner = "intel";
    repo = "llvm";
    rev = version;
    hash = "sha256-ObN7Pp1rvz6s6NMn6HTvCPoG7QYCT83sbJPIssnoby4=";
  };

  passthru = {
    isClang = targetDir == "llvm" || targetDir == "clang";
    isLLVM = targetDir == "llvm";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    perl
  ];

  buildInputs = [
    libz
    libxml2
    ncurses
  ];

  prePatch = ''
    cd ${targetDir}
  '';
}
