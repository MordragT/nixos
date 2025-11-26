{
  stdenv,
  stdenvNoCC,
  fetchinteldeb,
  autoPatchelfHook,
  dpkg,
  intel-dpcpp,
}: let
  major = "2025.3";
  version = "2025.3.0-409";

  dnnl = fetchinteldeb {
    package = "intel-oneapi-dnnl-${major}-${version}_amd64";
    hash = "sha256-RGgEKhN3B3Ib5ZaGG0BY3uUZDPPXs6osEtZDIorGNgw=";
  };
  dnnl-devel = fetchinteldeb {
    package = "intel-oneapi-dnnl-devel-${major}-${version}_amd64";
    hash = "sha256-JWzB8jR8iCoFNb5VLiBI8RVE4cT6jAJK4tzVTyzoHoc=";
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
