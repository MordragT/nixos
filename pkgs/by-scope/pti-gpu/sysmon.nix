{
  src,
  version,
  stdenv,
  cmake,
  autoAddDriverRunpath,
  level-zero,
  ocl-icd,
  python3,
}:
stdenv.mkDerivation {
  pname = "pti-gpu-sysmon";
  inherit src version;

  sourceRoot = "source/tools/sysmon";

  nativeBuildInputs = [
    cmake
    python3
    autoAddDriverRunpath
  ];

  buildInputs = [
    level-zero
    ocl-icd
  ];
}
