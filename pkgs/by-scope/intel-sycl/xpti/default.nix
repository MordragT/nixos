{
  stdenv,
  src,
  version,
  cmake,
}:
stdenv.mkDerivation {
  inherit src version;
  pname = "intel-xpti";

  sourceRoot = "${src.name}/xpti";

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
  ];
}
