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
  version = "0.1.1";
in
stdenv.mkDerivation {
  pname = "acestep-cpp-vulkan";
  inherit version;

  src = fetchFromGitHub {
    owner = "pwilkin";
    repo = "acestep.cpp";
    rev = "v${version}";
    hash = "sha256-zw2bG2Plwz1xFUPS13t33LVPaNqns/b7zLR4EjAalow=";
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

    install -Dm755 ace-synth $out/bin/
    install -Dm755 ace-lm $out/bin/
    install -Dm755 ace-server $out/bin/
    install -Dm755 ace-understand $out/bin/
    install -Dm755 quantize $out/bin/
    install -Dm755 neural-codec $out/bin/
    install -Dm766 mp3-codec $out/bin/
  '';

  meta = {
    description = "GGML-backed ACE-Step audio generation engine";
    homepage = "https://github.com/pwilkin/acestep.cpp";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
