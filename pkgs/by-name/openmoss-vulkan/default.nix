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
}:
let
  version = "0.3.0";
in
stdenv.mkDerivation {
  pname = "openmoss-vulkan";
  inherit version;

  src = fetchFromGitHub {
    owner = "pwilkin";
    repo = "openmoss";
    rev = "v${version}";
    hash = "sha256-OcigRwBn8wZypZrQ2JNomKPGoWL3E2gG/ewSpFMclXI=";
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
  ];

  cmakeFlags = [
    "-DGGML_VULKAN=ON"
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DCMAKE_SKIP_RPATH=OFF"
  ];

  postInstall = ''
    mkdir -p $out/bin

    install -Dm755 moss-tts-cli $out/bin/
    install -Dm755 moss-tts-server $out/bin/
  '';

  meta = {
    description = "GGML-backed moss inference engine";
    homepage = "https://github.com/pwilkin/openmoss";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
}
