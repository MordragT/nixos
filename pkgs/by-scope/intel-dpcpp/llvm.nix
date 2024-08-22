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
  major = "2024.2";
  version = "2024.2.0-981";

  base = fetchinteldeb {
    package = "intel-oneapi-dpcpp-cpp-${major}-${version}_amd64";
    hash = "sha256-y4oaBheX2Q/73NGvu/gVpZjGvt7CfBTaLHMp/I3RMvU=";
  };
  dpcpp = fetchinteldeb {
    package = "intel-oneapi-compiler-dpcpp-cpp-${major}-${version}_amd64";
    hash = "sha256-cYqInuZBnYEnhaCyavogKtUumGd8dx4MOHEcJ2YIArc=";
  };
  dpcpp-runtime = fetchinteldeb {
    package = "intel-oneapi-compiler-dpcpp-cpp-runtime-${major}-${version}_amd64";
    hash = "sha256-kVlkCSNIP/hcuTMI00fKZ6IqPOTaxZJd8cjfl7ThDg8=";
  };
  dpcpp-common = fetchinteldeb {
    package = "intel-oneapi-compiler-dpcpp-cpp-common-${major}-${version}_all";
    hash = "sha256-JmdEBQLaxSL9Rc7CXanMO+ULyEtJ3LOBiIf4yaIabZ8=";
  };
  shared = fetchinteldeb {
    package = "intel-oneapi-compiler-shared-${major}-${version}_amd64";
    hash = "sha256-gcGw7suZfwV6wSVj1m8UOvnelDAUcUJPhJkMHbR0vbU=";
  };
  shared-runtime = fetchinteldeb {
    package = "intel-oneapi-compiler-shared-runtime-${major}-${version}_amd64";
    hash = "sha256-d8MpTartoEsi8Lkd+IXZLKwmCmmzzaPJuMxd4Wn9BRg=";
  };
  shared-common = fetchinteldeb {
    package = "intel-oneapi-compiler-shared-common-${major}-${version}_all";
    hash = "sha256-QdzjErosg91s8D4xI7qVetsyFYNF20Rb9oqodD907L4=";
  };
  openmp = fetchinteldeb {
    package = "intel-oneapi-openmp-${major}-${version}_amd64";
    hash = "sha256-T7Z1jXgDdJNMOAt5+Lev7PMRRSbEDkTvPgE9Goyftrw=";
  };
  openmp-common = fetchinteldeb {
    package = "intel-oneapi-openmp-common-${major}-${version}_all";
    hash = "sha256-7MfL19P5N2FAuikIvK9O45MxblLaC7DkqVxUlLlD29E=";
  };

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
      cd ./opt/intel/oneapi/compiler/${major}

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
