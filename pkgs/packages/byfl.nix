{
  libcxxStdenv,
  fetchFromGitHub,
  llvm,
  perl,
  cmake,
  clang,
  bash,
}:
libcxxStdenv.mkDerivation {
  pname = "byfl";
  version = "master";

  src = fetchFromGitHub {
    sha256 = "jGmhQwBwJ9oA8PsEL19iekZeaUjy4XWSMASvkfzRJBs=";
    rev = "9e6c255bf6044feb74b54ef97ef56df3d3b17e91";
    owner = "lanl";
    repo = "Byfl";
  };

  postPatch = ''
    substituteInPlace lib/byfl/gen_opcode2name \
      --replace "/bin/echo" "echo"

    substituteInPlace tools/wrappers/make-bf-mpi \
      --replace "#! /bin/bash" "#! ${bash}/bin/bash" \
      --replace "#! /bin/sh" "#! ${bash}/bin/bash"

    substituteInPlace tools/wrappers/bf-clang.in \
      --replace "@CMAKE_INSTALL_FULL_BYFL_PLUGIN_DIR@/" "@CMAKE_INSTALL_FULL_LIBEXECDIR@/byfl/"
  '';

  buildInputs = [
    llvm
    llvm.dev
    perl
    clang
  ];

  nativeBuildInputs = [cmake];
}
