{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libva,
  xorg,
  libdrm,
  wayland,
  wayland-protocols,
  # , addOpenGLRunpath
  oneVPL-intel-gpu,
}:
# This was originally called mkl-dnn, then it was renamed to dnnl, and it has
# just recently been renamed again to oneDNN. See here for details:
# https://github.com/oneapi-src/oneDNN#oneapi-deep-neural-network-library-onednn
stdenv.mkDerivation rec {
  pname = "oneVPL";
  version = "2023.2.1";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneVPL";
    rev = "v${version}";
    sha256 = "hQ0/zZWvZuvOBEIP2xny7DtLvDua1ieH9hlh1UsztJc=";
  };

  nativeBuildInputs = [cmake pkg-config];

  buildInputs = [
    libva
    libdrm
    xorg.libpciaccess
    xorg.libX11
    xorg.libxcb
    wayland
    wayland-protocols
  ];

  # TODO one api has funky way for searching for the runtime
  # Therefore this isn't working atm: https://github.com/oneapi-src/oneAPI-spec/issues/418
  postFixup = ''
    patchelf --add-rpath ${oneVPL-intel-gpu}/lib $out/lib/libvpl.so.2.9
  '';

  # postFixup = ''
  #   for cmd in $out/bin/vpl-inspect; do
  #     wrapProgram $out/bin/$(basename "$cmd") \
  #       --suffix-each LD_LIBRARY_PATH : ${oneVPL-intel-gpu}/lib
  #   done
  # '';

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  meta = with lib; {
    description = "oneAPI Video Processing Library (oneVPL) dispatcher, tools, and examples ";
    homepage = "https://01.org/oneVPL";
    changelog = "https://github.com/oneapi-src/oneVPL/releases/tag/v${version}";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [mordrag];
  };
}
