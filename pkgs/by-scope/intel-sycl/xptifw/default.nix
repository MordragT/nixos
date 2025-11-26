{
  stdenv,
  src,
  version,
  cmake,
  parallel-hashmap,
  emhash,
}:
stdenv.mkDerivation {
  inherit src version;
  pname = "intel-xptifw";

  sourceRoot = "${src.name}/xptifw";

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    emhash
    parallel-hashmap
  ];
}
