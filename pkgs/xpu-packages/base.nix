{
  stdenv,
  name,
  cmakeFlags,
  targetDir ? name,
  extraBuildInputs ? [],
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
  # version = "18.0.0-nightly-2024-01-24";
  version = "nightly-2024-01-24";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "llvm";
    rev = version;
    hash = "sha256-ObN7Pp1rvz6s6NMn6HTvCPoG7QYCT83sbJPIssnoby4=";
  };

  passthru = {
    isClang = name == "llvm" || name == "clang";
    isLLVM = name == "llvm";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    perl
  ];

  buildInputs =
    [
      libz
      libxml2
      ncurses
    ]
    ++ extraBuildInputs;

  prePatch = ''
    cd ${targetDir}
  '';
}
