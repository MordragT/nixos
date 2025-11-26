{
  stdenv,
  src,
  version,
  cmake,
  python3,
}:
stdenv.mkDerivation {
  inherit src version;
  pname = "intel-openmp";

  sourceRoot = "${src.name}/openmp";

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    python3
  ];
}
