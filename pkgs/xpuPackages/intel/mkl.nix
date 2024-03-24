{
  stdenv,
  stdenvNoCC,
  fetchDeb,
  autoPatchelfHook,
  dpkg,
  intel-runtime,
  intel-mpi,
  ocl-icd,
}: let
  major = "2024.0";
  version = "2024.0.0-49656";

  mkl = fetchDeb {
    package = "intel-oneapi-mkl-${major}-${version}_amd64";
    hash = "sha256-EKhuJAUdbvSoD9g5xXDmKRkGOKPArJvMqZq4VfU0uVk=";
  };
  mkl-devel = fetchDeb {
    package = "intel-oneapi-mkl-devel-${major}-${version}_amd64";
    hash = "sha256-+rKm8V4Yv9m01CXycD5OmJKMV/UsT+68ntiG8JcGLoQ=";
  };
  mkl-runtime = fetchDeb {
    package = "intel-oneapi-runtime-mkl-2024-${version}_amd64";
    hash = "sha256-kk5xgAjYTTHKyWAAI1ueEHDfMVpa7NxBtQ0P5SA19xQ=";
  };
  mkl-common = fetchDeb {
    package = "intel-oneapi-mkl-common-${major}-${version}_all";
    hash = "sha256-7CtngTc5+koolfY0eaQay6IXSv4tDLigwckRnRMX2O8=";
  };
  mkl-common-devel = fetchDeb {
    package = "intel-oneapi-mkl-common-devel-${major}-${version}_all";
    hash = "sha256-rb8OqUb2OUbSm3+cdQw4pC6npl2MgWVbJoqix7uQgZI=";
  };
  mkl-common-runtime = fetchDeb {
    package = "intel-oneapi-runtime-mkl-common-2024-${version}_all";
    hash = "sha256-MvUUr3DFJX/rx6L57OwQXwDnQThFbfUYW3WBzfnkvB8=";
  };
in
  stdenvNoCC.mkDerivation {
    inherit version;
    pname = "intel-mkl";

    # dontUnpack = true;
    nativeBuildInputs = [autoPatchelfHook dpkg];

    buildInputs = [
      intel-runtime
      intel-mpi
      stdenv.cc.cc.lib
      ocl-icd
    ];

    unpackPhase = ''
      dpkg-deb -x ${mkl} .
      dpkg-deb -x ${mkl-devel} .
      dpkg-deb -x ${mkl-runtime} .
      dpkg-deb -x ${mkl-common} .
      dpkg-deb -x ${mkl-common-devel} .
      dpkg-deb -x ${mkl-common-runtime} .
    '';

    installPhase = ''
      mkdir -p $out
      mkdir -p $out/share

      cd ./opt/intel/oneapi/mkl/${major}

      mv bin $out/bin
      mv include $out/include
      mv lib $out/lib
      # mv lib32 $out/lib32

      ln -s $out/lib/libmkl_rt.so $out/lib/libblas.so
      ln -s $out/lib/libmkl_rt.so $out/lib/libcblas.so
      ln -s $out/lib/libmkl_rt.so $out/lib/liblapack.so
      ln -s $out/lib/libmkl_rt.so $out/lib/liblapacke.so
      ln -s $out/lib/libmkl_rt.so $out/lib/libblas.so.3
      ln -s $out/lib/libmkl_rt.so $out/lib/libcblas.so.3
      ln -s $out/lib/libmkl_rt.so $out/lib/liblapack.so.3
      ln -s $out/lib/libmkl_rt.so $out/lib/liblapacke.so.3

      ln -s $out/lib/libmkl_intel_ilp64.so.2 $out/lib/libblas64.so.3
      ln -s $out/lib/libmkl_intel_ilp64.so.2 $out/lib/libcblas64.so.3
      ln -s $out/lib/libmkl_intel_ilp64.so.2 $out/lib/liblapack64.so.3
      ln -s $out/lib/libmkl_intel_ilp64.so.2 $out/lib/liblapacke64.so.3
      ln -s $out/lib/liblapack.so.3 $out/lib/libblas64.so
      ln -s $out/lib/libcblas64.so.3 $out/lib/libcblas64.so
      ln -s $out/lib/liblapack64.so.3 $out/lib/liblapack64.so
      ln -s $out/lib/liblapacke64.so.3 $out/lib/liblapacke64.so
      rm $out/lib/intel64

      cd share

      mv doc $out/share/doc
      mv locale $out/share/locale
    '';
  }
