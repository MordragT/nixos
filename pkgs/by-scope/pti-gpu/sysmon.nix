{
  src,
  version,
  stdenv,
  cmake,
  python3,
  autoAddDriverRunpath,
  level-zero,
  ocl-icd,
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
