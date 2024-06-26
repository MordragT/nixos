{
  stdenv,
  stdenvNoCC,
  fetchinteldeb,
  autoPatchelfHook,
  dpkg,
  intel-dpcpp,
}: let
  major = "2021.12";
  version = "2021.12.0-309";

  ccl = fetchinteldeb {
    package = "intel-oneapi-ccl-${major}-${version}_amd64";
    hash = "sha256-o9t0/zbkZPjqtEwWY5uDRJT40jGTp/xEaXDVtNNcbWk=";
  };
  ccl-devel = fetchinteldeb {
    package = "intel-oneapi-ccl-devel-${major}-${version}_amd64";
    hash = "sha256-nmHeIAPjHz9Rk9HP1tazlIvj7+eavzH2of/ky91qRCg=";
  };
in
  stdenvNoCC.mkDerivation {
    inherit version;
    pname = "intel-ccl";

    dontStrip = true;

    nativeBuildInputs = [autoPatchelfHook dpkg];

    buildInputs = [
      stdenv.cc.cc.lib
      intel-dpcpp.runtime
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
