{
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  level-zero,
  oneTBB,
  zlib,
  libxml2,
}: let
  # https://apt.repos.intel.com/oneapi/dists/all/main/binary-amd64/Packages
  # https://apt.repos.intel.com/oneapi/dists/all/main/binary-all/Packages
  fetchDeb = {
    package,
    hash,
  }:
    fetchurl {
      inherit hash;
      url = "https://apt.repos.intel.com/oneapi/pool/main/${package}.deb";
    };
  version = "2024.0-2024.0.1-49878";

  base = fetchDeb {
    package = "intel-oneapi-dpcpp-cpp-${version}_amd64";
    hash = "sha256-Jrl/f5ihNB/U4EWXsRQcXimrpqBkMs7QTro8suYjgr4=";
  };
  dpcpp = fetchDeb {
    package = "intel-oneapi-compiler-dpcpp-cpp-${version}_amd64";
    hash = "sha256-Tg9OcEb/3xm6HGftcnzsm0XTZuAx3OHw2LveAVPuwIM=";
  };
  dpcpp-runtime = fetchDeb {
    package = "intel-oneapi-compiler-dpcpp-cpp-runtime-${version}_amd64";
    hash = "sha256-ylUWk+5z0GUUPXtpoSXvPadeRuW1zft9tUQb+eeyHkc=";
  };
  dpcpp-common = fetchDeb {
    package = "intel-oneapi-compiler-dpcpp-cpp-common-${version}_all";
    hash = "sha256-t8IaRMoe0lwxIplROH7G9BgOJRsy6Du5gNcCVYXW0xY=";
  };
  shared = fetchDeb {
    package = "intel-oneapi-compiler-shared-${version}_amd64";
    hash = "sha256-wNhDjW4aGxxeK4otgIydjTSR9u4xV+1u1neDMiVb74k=";
  };
  shared-runtime = fetchDeb {
    package = "intel-oneapi-compiler-shared-runtime-${version}_amd64";
    hash = "sha256-YA4yCLz5WdQqYCvjDUieOROzXL3waM0vjLueZWJsS2U=";
  };
  shared-common = fetchDeb {
    package = "intel-oneapi-compiler-shared-common-${version}_all";
    hash = "sha256-GxoNvhBndvYGmuMt+auh6Bs88qZPgudw+6jdQfX81I8=";
  };

  classicVersion = "2023.2.3-2023.2.3-20";

  classic = fetchDeb {
    package = "intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic-${classicVersion}_amd64";
    hash = "sha256-9TJyy9tdyNIJDw+/7AAMWB9FY6QPwnXbL2JoZbZoBUA=";
  };
  classic-runtime = fetchDeb {
    package = "intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic-runtime-${classicVersion}_amd64";
    hash = "sha256-rIJdyjAxeSa2N3F4kZ7Y6c/GugQFER0vx5120O0crBE=";
  };
  classic-common = fetchDeb {
    package = "intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic-common-${classicVersion}_all";
    hash = "sha256-eA2K2H4T1Zn10OW+/Z+e+SJ5fxqPekKukkGG5uz8NRU=";
  };
in
  stdenvNoCC.mkDerivation {
    inherit version;
    pname = "dpcpp";

    # dontUnpack = true;
    nativeBuildInputs = [autoPatchelfHook dpkg];

    autoPatchelfIgnoreMissingDeps = [
      "libonnxruntime.1.12.22.721.so"
    ];

    buildInputs = [
      level-zero
      oneTBB
      zlib
      libxml2
      stdenv.cc.cc.lib
    ];

    unpackPhase = ''
      dpkg-deb -x ${base} .
      dpkg-deb -x ${dpcpp} .
      dpkg-deb -x ${dpcpp-runtime} .
      dpkg-deb -x ${dpcpp-common} .
      dpkg-deb -x ${shared} .
      dpkg-deb -x ${shared-runtime} .
      dpkg-deb -x ${shared-common} .
      dpkg-deb -x ${classic} .
      dpkg-deb -x ${classic-runtime} .
      dpkg-deb -x ${classic-common} .
    '';

    installPhase = ''
      mv ./opt/intel/oneapi/compiler/2024.0 $out
      ln -s $out/bin/icx-cc $out/bin/c++
      rm -rf $out/opt/oclfpga
    '';
  }
