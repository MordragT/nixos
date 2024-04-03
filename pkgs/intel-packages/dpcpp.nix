{
  stdenv,
  stdenvNoCC,
  fetchdeb,
  autoPatchelfHook,
  dpkg,
  level-zero,
  tbb,
  zlib,
  libxml2,
  libffi_3_3,
  elfutils,
}: let
  major = "2024.0";
  version = "2024.0.1-49878";

  base = fetchdeb {
    package = "intel-oneapi-dpcpp-cpp-${major}-${version}_amd64";
    hash = "sha256-Jrl/f5ihNB/U4EWXsRQcXimrpqBkMs7QTro8suYjgr4=";
  };
  dpcpp = fetchdeb {
    package = "intel-oneapi-compiler-dpcpp-cpp-${major}-${version}_amd64";
    hash = "sha256-Tg9OcEb/3xm6HGftcnzsm0XTZuAx3OHw2LveAVPuwIM=";
  };
  dpcpp-runtime = fetchdeb {
    package = "intel-oneapi-compiler-dpcpp-cpp-runtime-${major}-${version}_amd64";
    hash = "sha256-ylUWk+5z0GUUPXtpoSXvPadeRuW1zft9tUQb+eeyHkc=";
  };
  dpcpp-common = fetchdeb {
    package = "intel-oneapi-compiler-dpcpp-cpp-common-${major}-${version}_all";
    hash = "sha256-t8IaRMoe0lwxIplROH7G9BgOJRsy6Du5gNcCVYXW0xY=";
  };
  shared = fetchdeb {
    package = "intel-oneapi-compiler-shared-${major}-${version}_amd64";
    hash = "sha256-wNhDjW4aGxxeK4otgIydjTSR9u4xV+1u1neDMiVb74k=";
  };
  shared-runtime = fetchdeb {
    package = "intel-oneapi-compiler-shared-runtime-${major}-${version}_amd64";
    hash = "sha256-YA4yCLz5WdQqYCvjDUieOROzXL3waM0vjLueZWJsS2U=";
  };
  shared-common = fetchdeb {
    package = "intel-oneapi-compiler-shared-common-${major}-${version}_all";
    hash = "sha256-GxoNvhBndvYGmuMt+auh6Bs88qZPgudw+6jdQfX81I8=";
  };
  openmp = fetchdeb {
    package = "intel-oneapi-openmp-${major}-${version}_amd64";
    hash = "sha256-U8sKp16d2hqTqFymT72EGj4cLVZpOhL2CjgqrLe5de8=";
  };
  openmp-common = fetchdeb {
    package = "intel-oneapi-openmp-common-${major}-${version}_all";
    hash = "sha256-8I8PLGcfUiKFZCVAJXk+51N5Dj395NZ/ClGRoQBzfr4=";
  };

  classicVersion = "2023.2.3-2023.2.3-20";

  classic = fetchdeb {
    package = "intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic-${classicVersion}_amd64";
    hash = "sha256-9TJyy9tdyNIJDw+/7AAMWB9FY6QPwnXbL2JoZbZoBUA=";
  };
  classic-runtime = fetchdeb {
    package = "intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic-runtime-${classicVersion}_amd64";
    hash = "sha256-rIJdyjAxeSa2N3F4kZ7Y6c/GugQFER0vx5120O0crBE=";
  };
  classic-common = fetchdeb {
    package = "intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic-common-${classicVersion}_all";
    hash = "sha256-eA2K2H4T1Zn10OW+/Z+e+SJ5fxqPekKukkGG5uz8NRU=";
  };
in
  stdenvNoCC.mkDerivation {
    inherit version;
    pname = "intel-dpcpp";

    # dontUnpack = true;
    nativeBuildInputs = [autoPatchelfHook dpkg];

    buildInputs = [
      tbb
      stdenv.cc.cc.lib
      level-zero
      zlib
      libxml2
      libffi_3_3
      elfutils
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
      mv include $out/include
      mv lib $out/lib
      mv share $out/share
    '';
  }
