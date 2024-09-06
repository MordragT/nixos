{
  stdenv,
  stdenvNoCC,
  fetchurl,
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
  pins = builtins.fromJSON (builtins.readFile ./default.lock);
  version = "2024.2";

  base = fetchurl {
    inherit (pins."intel-oneapi-dpcpp-cpp-${version}") url hash;
  };
  dpcpp = fetchurl {
    inherit (pins."intel-oneapi-compiler-dpcpp-cpp-${version}") url hash;
  };
  dpcpp-runtime = fetchurl {
    inherit (pins."intel-oneapi-compiler-dpcpp-cpp-runtime-${version}") url hash;
  };
  dpcpp-common = fetchurl {
    inherit (pins."intel-oneapi-compiler-dpcpp-cpp-common-${version}") url hash;
  };
  shared = fetchurl {
    inherit (pins."intel-oneapi-compiler-shared-${version}") url hash;
  };
  shared-runtime = fetchurl {
    inherit (pins."intel-oneapi-compiler-shared-runtime-${version}") url hash;
  };
  shared-common = fetchurl {
    inherit (pins."intel-oneapi-compiler-shared-common-${version}") url hash;
  };
  openmp = fetchurl {
    inherit (pins."intel-oneapi-openmp-${version}") url hash;
  };
  openmp-common = fetchurl {
    inherit (pins."intel-oneapi-openmp-common-${version}") url hash;
  };

  classicVersion = "2023.2.4";

  classic = fetchurl {
    inherit (pins."intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic-${classicVersion}") url hash;
  };
  classic-runtime = fetchurl {
    inherit (pins."intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic-runtime-${classicVersion}") url hash;
  };
  classic-common = fetchurl {
    inherit (pins."intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic-common-${classicVersion}") url hash;
  };
in
  stdenvNoCC.mkDerivation {
    inherit version;
    pname = "intel-dpcpp";

    # dontUnpack = true;
    dontStrip = true;

    outputs = ["out" "lib" "dev" "rsrc"];

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
      cd ./opt/intel/oneapi/compiler/${version}

      mv lib/clang/19 $rsrc

      mkdir $out
      mv bin $out/bin
      mv env $out/env
      mv etc/compiler $out/env/compiler
      mv share $out/share

      mkdir $dev
      mv include $dev/include
      mv opt/compiler/include $dev/include/compiler
      mkdir $dev/lib
      mv lib/pkgconfig $dev/lib/pkgconfig
      mv lib/cmake $dev/lib/cmake
      sed -r -i "s|^prefix=.*|prefix=$lib|g" $dev/lib/pkgconfig/openmp.pc

      mkdir $lib
      mv lib $lib/lib
      mv opt/compiler/lib $lib/lib/compiler
      # remove libopencl to link against patched opencl-loader from nixos
      rm $lib/lib/libOpenCL.so*
      rm $lib/lib/libhwloc.so*
      rm $lib/lib/libtcm*
    '';
  }
