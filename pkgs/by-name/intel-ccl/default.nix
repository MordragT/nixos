{
  stdenv,
  stdenvNoCC,
  fetchinteldeb,
  autoPatchelfHook,
  dpkg,
  intel-dpcpp,
}: let
  major = "2021.15";
  version = "2021.15.0-397";

  ccl = fetchinteldeb {
    package = "intel-oneapi-ccl-${major}-${version}_amd64";
    hash = "sha256-ZNMyXR139v/AmqgQ2cuaAlnMFLe5vOozR5UyKJbAdtc=";
  };
  ccl-devel = fetchinteldeb {
    package = "intel-oneapi-ccl-devel-${major}-${version}_amd64";
    hash = "sha256-fzW2xXLkujKOPGyxXqO+yb5CE3VYvaGUWZh1sdzvh84=";
  };
in
  stdenvNoCC.mkDerivation {
    inherit version;
    pname = "intel-ccl";

    dontStrip = true;

    nativeBuildInputs = [autoPatchelfHook dpkg];

    buildInputs = [
      stdenv.cc.cc.lib
      intel-dpcpp.llvm.lib
    ];

    unpackPhase = ''
      dpkg-deb -x ${ccl} .
      dpkg-deb -x ${ccl-devel} .
    '';

    installPhase = ''
      mkdir -p $out

      cd ./opt/intel/oneapi/ccl/${major}

      mv env $out/env
      mv etc/ccl $out/env/ccl
      mv include $out/include
      mv lib $out/lib
      mv share $out/share
    '';
  }
