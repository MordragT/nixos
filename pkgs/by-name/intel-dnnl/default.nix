{
  stdenv,
  stdenvNoCC,
  fetchinteldeb,
  autoPatchelfHook,
  dpkg,
  intel-dpcpp,
}: let
  major = "2025.1";
  version = "2025.1.0-643";

  dnnl = fetchinteldeb {
    package = "intel-oneapi-dnnl-${major}-${version}_amd64";
    hash = "sha256-OvU238WlcgyPbE1RiD7WruXv8LwvQozuGpv4AIOcSek=";
  };
  dnnl-devel = fetchinteldeb {
    package = "intel-oneapi-dnnl-devel-${major}-${version}_amd64";
    hash = "sha256-3tKcBvIVGvf9YlbGLzSqNq5eUub1CoAyhFxLcrZ2tQg=";
  };
in
  stdenvNoCC.mkDerivation {
    inherit version;
    pname = "intel-dnnl";

    dontStrip = true;

    nativeBuildInputs = [autoPatchelfHook dpkg];

    buildInputs = [
      stdenv.cc.cc.lib
      intel-dpcpp.llvm.lib
    ];

    unpackPhase = ''
      dpkg-deb -x ${dnnl} .
      dpkg-deb -x ${dnnl-devel} .
    '';

    installPhase = ''
      mkdir -p $out

      cd ./opt/intel/oneapi/dnnl/${major}

      mv env $out/env
      mv etc/dnnl $out/env/dnnl
      mv include $out/include
      mv lib $out/lib
      mv share $out/share
    '';
  }
