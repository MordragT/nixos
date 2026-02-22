{
  stdenv,
  stdenvNoCC,
  fetchinteldeb,
  autoPatchelfHook,
  dpkg,
  intel-dpcpp,
  intel-mpi,
}:
let
  major = "2021.17";
  version = "2021.17.0-271";

  ccl = fetchinteldeb {
    package = "intel-oneapi-ccl-${major}-${version}_amd64";
    hash = "sha256-1SoHfmMESAc8Bhs9RroYzyKiBXybOITTWA7qWUjclSk=";
  };
  ccl-devel = fetchinteldeb {
    package = "intel-oneapi-ccl-devel-${major}-${version}_amd64";
    hash = "sha256-eS2C2oktwZYDqiH3QN3xebeAqFFxg9iqsky08hEhHz0=";
  };
in
stdenvNoCC.mkDerivation {
  inherit version;
  pname = "intel-ccl";

  dontStrip = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    intel-dpcpp.llvm.lib
    intel-mpi
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
