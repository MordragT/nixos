{
  src,
  version,
  stdenv,
  cmake,
  python3,
  autoAddDriverRunpath,
  level-zero,
  ocl-icd,
  opencl-headers,
}:
stdenv.mkDerivation {
  pname = "pti-gpu-onetrace";
  inherit src version;

  sourceRoot = "source/tools/onetrace";

  nativeBuildInputs = [
    cmake
    python3
    autoAddDriverRunpath
  ];

  buildInputs = [
    level-zero
    ocl-icd
    opencl-headers
  ];

  meta.broken = true;
}
