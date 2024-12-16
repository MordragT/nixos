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
  pname = "intel-xpti";

  sourceRoot = "${src.name}/xpti";

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];
}
