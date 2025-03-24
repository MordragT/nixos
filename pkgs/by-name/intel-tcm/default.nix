{
  stdenv,
  stdenvNoCC,
  fetchinteldeb,
  autoPatchelfHook,
  dpkg,
  hwloc,
}: let
  major = "1.3";
  version = "1.3.0-309";

  tcm = fetchinteldeb {
    package = "intel-oneapi-tcm-${major}-${version}_amd64";
    hash = "sha256-a5kSWyurIB7GX7541j551c6m+escW3ZYHX/90djHVqw=";
  };
  # tcm-runtime = fetchinteldeb {
  #   package = "intel-oneapi-runtime-tcm-1-${version}_amd64";
  #   hash = "";
  # };
in
  stdenvNoCC.mkDerivation {
    inherit version;
    pname = "intel-tcm";

    # dontUnpack = true;
    dontStrip = true;

    nativeBuildInputs = [autoPatchelfHook dpkg];

    buildInputs = [
      stdenv.cc.cc.lib
      hwloc
    ];

    unpackPhase = ''
      dpkg-deb -x ${tcm} .
    '';

    installPhase = ''
      mkdir $out

      cd ./opt/intel/oneapi/tcm/${major}

      rm lib/libhwloc.so*

      mv lib $out/lib
      mv share $out/share
    '';
  }
