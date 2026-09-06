{
  stdenv,
  oneapi-math,
  oneapi-math-sycl-blas,
  mkl,
}:

stdenv.mkDerivation {
  pname = "oneapi-math-mkl-compat";
  inherit (oneapi-math) version;

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/lib/cmake/MKL
    cp ${./MKLConfig.cmake} $out/lib/cmake/MKL/MKLConfig.cmake
    cp ${./MKLConfigVersion.cmake} $out/lib/cmake/MKL/MKLConfigVersion.cmake
  '';

  propagatedBuildInputs = [
    oneapi-math
    oneapi-math-sycl-blas
    mkl
  ];

  meta = {
    description = "Compatibility layer mapping Intel MKL CMake targets to open-source oneMath and Nix MKL";
  };
}
