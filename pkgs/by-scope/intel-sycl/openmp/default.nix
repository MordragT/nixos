{
  stdenv,
  src,
  version,
  cmake,
  pkg-config,
  python3,
}:
stdenv.mkDerivation {
  inherit src version;
  pname = "intel-openmp";

  sourceRoot = "${src.name}/openmp";

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];
}
