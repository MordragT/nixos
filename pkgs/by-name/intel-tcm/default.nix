{
  stdenv,
  stdenvNoCC,
  fetchinteldeb,
  autoPatchelfHook,
  dpkg,
  hwloc,
}: let
  major = "1.2";
  version = "1.2.0-589";

  tcm = fetchinteldeb {
    package = "intel-oneapi-tcm-${major}-${version}_amd64";
    hash = "";
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
      rm lib32/libhwloc.so*

      mv lib $out/lib
      mv lib32 $out/lib32
      mv share $out/share
    '';
  }
