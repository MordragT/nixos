{
  stdenv,
  src,
  version,
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
}: let
  emhash = fetchFromGitHub {
    owner = "ktprime";
    repo = "emhash";
    rev = "96dcae6fac2f5f90ce97c9efee61a1d702ddd634";
    hash = "sha256-yvnu8TMIX6KJZlYJv3ggLf9kOViKXeUp4NyhRg4m5Dg=";
  };
  parallel-hashmap = fetchFromGitHub {
    owner = "greg7mdp";
    repo = "parallel-hashmap";
    rev = "8a889d3699b3c09ade435641fb034427f3fd12b6";
    hash = "sha256-hcA5sjL0LHuddEJdJdFGRbaEXOAhh78wRa6csmxi4Rk=";
  };
in
  stdenv.mkDerivation {
    inherit src version;
    pname = "intel-xptifw";

    sourceRoot = "${src.name}/xptifw";

    nativeBuildInputs = [
      cmake
      pkg-config
      python3
    ];

    cmakeFlags = [
      "-DXPTIFW_EMHASH_HEADERS=${emhash}"
      "-DXPTIFW_PARALLEL_HASHMAP_HEADERS=${parallel-hashmap}"
    ];

    patches = [
      ./cmake.patch
    ];
  }
