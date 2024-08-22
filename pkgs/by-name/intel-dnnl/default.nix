{
  stdenv,
  stdenvNoCC,
  fetchinteldeb,
  autoPatchelfHook,
  dpkg,
  intel-dpcpp,
}: let
  major = "2024.1";
  version = "2024.1.0-567";

  dnnl = fetchinteldeb {
    package = "intel-oneapi-dnnl-${major}-${version}_amd64";
    hash = "sha256-F+F2HOlhSKe9UjvW+FpFT6bJDfD7qiJp06EhsQiBDYw=";
  };
  dnnl-devel = fetchinteldeb {
    package = "intel-oneapi-dnnl-devel-${major}-${version}_amd64";
    hash = "sha256-k8aTL+KA+sPT90HpWA5+MlwM565gFMY2yDiNhg2ReWM=";
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
