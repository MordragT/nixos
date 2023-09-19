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
  intel-media-driver,
}:
# This was originally called mkl-dnn, then it was renamed to dnnl, and it has
# just recently been renamed again to oneDNN. See here for details:
# https://github.com/oneapi-src/oneDNN#oneapi-deep-neural-network-library-onednn
stdenv.mkDerivation rec {
  pname = "oneVPL-intel-gpu";
  version = "23.1.5";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneVPL-intel-gpu";
    rev = "intel-onevpl-${version}";
    sha256 = "AxoGMfOvIX3BSPWXyHNYBL9RiPxZ6QPM5RYc5nXs09Y=";
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
    intel-media-driver
  ];

  # Tests fail on some Hydra builders, because they do not support SSE4.2.
  doCheck = false;

  meta = with lib; {
    description = "oneAPI Video Processing Library (oneVPL) dispatcher, tools, and examples ";
    homepage = "https://01.org/oneVPL";
    changelog = "https://github.com/oneapi-src/oneVPL-intel-gpu/releases/tag/intel-onevpl-${version}";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [mordrag];
  };
}
