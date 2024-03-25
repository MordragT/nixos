{
  stdenv,
  stdenvNoCC,
  fetchdeb,
  autoPatchelfHook,
  dpkg,
  hwloc,
}: let
  major = "2021.11";
  version = "2021.11.0-49513";

  tbb = fetchdeb {
    package = "intel-oneapi-tbb-${major}-${version}_amd64";
    hash = "sha256-YQZ9v3WuAZI6KUCE7kAZGhN8WHUSOhm3ZCRFIiMvF2k=";
  };
  tbb-devel = fetchdeb {
    package = "intel-oneapi-tbb-devel-${major}-${version}_amd64";
    hash = "sha256-9RqbE/pRt9zrr0JGWPTz7ArgUr9dUXhuOFzHFk3Fd0M=";
  };
  tbb-runtime = fetchdeb {
    package = "intel-oneapi-runtime-tbb-2021-${version}_amd64";
    hash = "sha256-CB8Pta09RNodvAa0J9Rdaf4dotO6NC8JY40iScqXA/g=";
  };
  tbb-common = fetchdeb {
    package = "intel-oneapi-tbb-common-${major}-${version}_all";
    hash = "sha256-8B3gFiZmvDZoWZ79NVWnPuKye6J2nfDwMshnWJZYXcA=";
  };
  tbb-common-devel = fetchdeb {
    package = "intel-oneapi-tbb-common-devel-${major}-${version}_all";
    hash = "sha256-BTMP1j+aoVMmc6ZONt/Ltfgxo8SvLesNxqn7X4TSOqE=";
  };
  tbb-common-runtime = fetchdeb {
    package = "intel-oneapi-runtime-tbb-common-2021-${version}_all";
    hash = "sha256-Hk0SU8kWilVYjt1t2WWkdKEtbFLLdMiXH25Jbk2Odmo=";
  };
in
  stdenvNoCC.mkDerivation {
    inherit version;
    pname = "intel-tbb";

    # dontUnpack = true;
    nativeBuildInputs = [autoPatchelfHook dpkg];

    buildInputs = [
      stdenv.cc.cc.lib
      hwloc
    ];

    autoPatchelfIgnoreMissingDeps = ["libhwloc.so.5"];

    unpackPhase = ''
      dpkg-deb -x ${tbb} .
      dpkg-deb -x ${tbb-devel} .
      dpkg-deb -x ${tbb-runtime} .
      dpkg-deb -x ${tbb-common} .
      dpkg-deb -x ${tbb-common-devel} .
      dpkg-deb -x ${tbb-common-runtime} .
    '';

    installPhase = ''
      mkdir -p $out

      cd ./opt/intel/oneapi/tbb/${major}

      mv include $out/include
      mv lib $out/lib
      mv lib32 $out/lib32
      mv share $out/share
    '';
  }
