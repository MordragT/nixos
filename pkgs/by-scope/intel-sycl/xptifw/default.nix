{
  stdenv,
  src,
  version,
  pins,
  cmake,
  pkg-config,
  python3,
}:
stdenv.mkDerivation {
  inherit src version;
  pname = "intel-xptifw";

  sourceRoot = "${src.name}/xptifw";

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  cmakeFlags = [
    "-DXPTIFW_EMHASH_HEADERS=${pins.emhash}"
    "-DXPTIFW_PARALLEL_HASHMAP_HEADERS=${pins.parallel-hashmap}"
  ];

  patches = [
    ./cmake.patch
  ];
}
