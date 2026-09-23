{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  shaderc,
  vulkan-loader,
  vulkan-headers,
  # libwebp,
}:
let
  version = "0.6.0";
in
stdenv.mkDerivation {
  pname = "trellis-cpp-vulkan";
  inherit version;

  src = fetchFromGitHub {
    owner = "pwilkin";
    repo = "trellis.cpp";
    rev = "v${version}";
    hash = "sha256-eahL/TTzELvT7IohJNVTpy96+oajGeWMAcHY16YsO4s=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    shaderc
  ];

  buildInputs = [
    vulkan-loader
    vulkan-headers
    # libwebp # more cmake shenanigans requried, see below
  ];

  cmakeFlags = [
    "-DGGML_VULKAN=ON"
    "-DTRELLIS_WEBP=OFF" # turned off for now
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DCMAKE_SKIP_RPATH=OFF"
  ];

  postInstall = ''
    mkdir -p $out/bin

    install -Dm755 trellis-cli $out/bin/
    install -Dm755 trellis-decode-replay $out/bin/
    install -Dm755 trellis-server $out/bin/
    install -Dm755 trellis-smoke $out/bin/
  '';

  meta = {
    description = "GGML-backed structured prediction engine";
    homepage = "https://github.com/pwilkin/trellis.cpp";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
