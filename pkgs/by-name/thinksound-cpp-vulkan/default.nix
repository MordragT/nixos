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
  version = "0.1.2";
in
stdenv.mkDerivation {
  pname = "thinksound-cpp-vulkan";
  inherit version;

  src = fetchFromGitHub {
    owner = "pwilkin";
    repo = "thinksound.cpp";
    rev = "v${version}";
    hash = "sha256-tpkCckWPXSeRNqdp8C2Xhg2lL85TyX5jizxHtd+E7es=";
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

    install -Dm755 ts-server $out/bin/
  '';

  meta = {
    description = "GGML-backed audio inference engine";
    homepage = "https://github.com/pwilkin/thinksound.cpp";
    # license = not sure
    platforms = lib.platforms.linux;
  };
}
