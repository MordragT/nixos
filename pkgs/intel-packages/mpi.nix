{
  stdenv,
  stdenvNoCC,
  fetchdeb,
  autoPatchelfHook,
  dpkg,
  level-zero,
  libfabric,
}: let
  major = "2021.11";
  version = "2021.11.0-49493";

  mpi = fetchdeb {
    package = "intel-oneapi-mpi-${major}-${version}_amd64";
    hash = "sha256-PaRmjyPrYXW3i4lab0TLN1IpcU8KLkL8MF2GUpQdxbk=";
  };
  mpi-devel = fetchdeb {
    package = "intel-oneapi-mpi-devel-${major}-${version}_amd64";
    hash = "sha256-NuCtxFKDhPwInTV7vRmFQ3iXl2ytzLDoDvn1oS9YdWM=";
  };
  mpi-runtime = fetchdeb {
    package = "intel-oneapi-runtime-mpi-2021-${version}_amd64";
    hash = "sha256-c1QriM1bPMFG787aVpcTq71fSHqPdMQHugtJUNSQhTI=";
  };
in
  stdenvNoCC.mkDerivation {
    inherit version;
    pname = "intel-mpi";

    # dontUnpack = true;
    nativeBuildInputs = [autoPatchelfHook dpkg];

    buildInputs = [
      stdenv.cc.cc.lib
      level-zero
      libfabric
    ];

    unpackPhase = ''
      dpkg-deb -x ${mpi} .
      dpkg-deb -x ${mpi-devel} .
      dpkg-deb -x ${mpi-runtime} .
    '';

    installPhase = ''
      mkdir -p $out
      mkdir -p $out/share

      cd ./opt/intel/oneapi/mpi/${major}

      mv bin $out/bin
      mv include $out/include
      mv lib $out/lib

      cd share

      mv doc $out/share/doc
      mv man $out/share/man
    '';
  }
