{
  stdenv,
  stdenvNoCC,
  fetchinteldeb,
  autoPatchelfHook,
  dpkg,
  level-zero,
  intel-tbb,
  ocl-icd,
  zlib,
  libxml2,
  libffi_3_3,
  elfutils,
}: let
  # major = "2024.0";
  # version = "2024.0.1-49878";
  major = "2024.1";
  version = "2024.1.0-963";

  base = fetchinteldeb {
    package = "intel-oneapi-dpcpp-cpp-${major}-${version}_amd64";
    hash = "sha256-bDuB5yQHzLSW3H9dmmyK/65bKsrgZTH35I3kQHxKS78=";
  };
  dpcpp = fetchinteldeb {
    package = "intel-oneapi-compiler-dpcpp-cpp-${major}-${version}_amd64";
    hash = "sha256-LaDDH3v0NbN6aKTbGrDRkMOQHJOpbX+lC35GhZWqSrI=";
  };
  dpcpp-runtime = fetchinteldeb {
    package = "intel-oneapi-compiler-dpcpp-cpp-runtime-${major}-${version}_amd64";
    hash = "sha256-VAjAL6FgEtJ/gZ7xl5tj6T9MhS1lixmWMXV6smPIQWk=";
  };
  dpcpp-common = fetchinteldeb {
    package = "intel-oneapi-compiler-dpcpp-cpp-common-${major}-${version}_all";
    hash = "sha256-f/fB12laU5dCtYHSUYHT/1Tmais4uPN+PRSDZXk6Gck=";
  };
  shared = fetchinteldeb {
    package = "intel-oneapi-compiler-shared-${major}-${version}_amd64";
    hash = "sha256-8u+HeYfFHmkllKRWElUds8VfIBe8aDtn8+i9hT0UgqA=";
  };
  shared-runtime = fetchinteldeb {
    package = "intel-oneapi-compiler-shared-runtime-${major}-${version}_amd64";
    hash = "sha256-MoIkBLT/k0jtgbxZXOYu5EGBAMGUQN79Z7O6Nsd6KuA=";
  };
  shared-common = fetchinteldeb {
    package = "intel-oneapi-compiler-shared-common-${major}-${version}_all";
    hash = "sha256-rr9l6SPaVWsdcFILiuirjMNeAa7t5boxPlGt/ZI5DnE=";
  };
  openmp = fetchinteldeb {
    package = "intel-oneapi-openmp-${major}-${version}_amd64";
    hash = "sha256-TgYajUyihTGYVVvaBzaObUilKHoy+4PICfFedy97sQY=";
  };
  openmp-common = fetchinteldeb {
    package = "intel-oneapi-openmp-common-${major}-${version}_all";
    hash = "sha256-13Sw3YL8NcHW4Eo47+Flcwc74aWz1ZdkWeeAjsOepXc=";
  };

  # classicVersion = "2023.2.3-2023.2.3-20";
  classicVersion = "2023.2.4-2023.2.4-49553";

  classic = fetchinteldeb {
    package = "intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic-${classicVersion}_amd64";
    hash = "sha256-hqY7QJyah3A9/3uzvBTebAu6qBgj+QWTmilLL0a6idc=";
  };
  classic-runtime = fetchinteldeb {
    package = "intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic-runtime-${classicVersion}_amd64";
    hash = "sha256-OmzPp1RQoIMfQulwHujSvaBFSdhJRXcg/20wfXWI+q4=";
  };
  classic-common = fetchinteldeb {
    package = "intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic-common-${classicVersion}_all";
    hash = "sha256-svPb1QNVT3i14/Lv64R1sF1X+Z/ufJ4OyZmZk2jFNoU=";
  };
in
  stdenvNoCC.mkDerivation {
    inherit version;
    pname = "intel-dpcpp";

    # dontUnpack = true;
    dontStrip = true;

    nativeBuildInputs = [
      autoPatchelfHook
      dpkg
    ];

    buildInputs = [
      intel-tbb
      stdenv.cc.cc.lib
      level-zero
      zlib
      libxml2
      libffi_3_3
      elfutils
      ocl-icd
    ];

    unpackPhase = ''
      dpkg-deb -x ${base} .
      dpkg-deb -x ${dpcpp} .
      dpkg-deb -x ${dpcpp-runtime} .
      dpkg-deb -x ${dpcpp-common} .
      dpkg-deb -x ${shared} .
      dpkg-deb -x ${shared-runtime} .
      dpkg-deb -x ${shared-common} .
      dpkg-deb -x ${openmp} .
      dpkg-deb -x ${openmp-common} .
      dpkg-deb -x ${classic} .
      dpkg-deb -x ${classic-runtime} .
      dpkg-deb -x ${classic-common} .
    '';

    installPhase = ''
      mkdir -p $out

      cd ./opt/intel/oneapi/compiler/${major}

      mv bin $out/bin
      rm $out/bin/aocl

      mv env $out/env
      mv etc/compiler $out/env/compiler

      mv include $out/include
      mv opt/compiler/include $out/include/compiler

      mv lib $out/lib
      mv opt/compiler/lib/* $out/lib/compiler/

      # remove libopencl to link against patched opencl-loader from nixos
      rm $out/lib/libOpenCL.so
      rm $out/lib/libOpenCL.so.1
      rm $out/lib/libOpenCL.so.1.2

      mv share $out/share

      sed -r -i "s|^prefix=.*|prefix=$out|g" $out/lib/pkgconfig/openmp.pc
    '';
  }
