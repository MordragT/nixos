{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  alsa-lib,
  glslang,
  libglvnd,
  vulkan-headers,
  vulkan-loader,
  xorg,
}:
stdenv.mkDerivation rec {
  pname = "opengothic";
  version = "master";

  src = fetchFromGitHub {
    owner = "Try";
    repo = "OpenGothic";
    rev = "794e575f006698900eaf826d17eb1c98061795ad";
    sha256 = "sha256-geyUc4LeiI9uqjy4YtNi0BTa76JqmcEtvy71GjdFTd0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo"
    "-DCMAKE_SKIP_RPATH=OFF"
  ];

  buildInputs = [
    alsa-lib # cannot find audio device
    glslang
    libglvnd
    vulkan-headers
    vulkan-loader
    xorg.libX11
    xorg.libXcursor
  ];

  postInstall = ''
    mv opengothic/lib* $out/lib/
    mv $out/bin/Gothic2Notr $out/bin/opengothic
  '';

  meta = with lib; {
    description = "Reimplementation of Gothic 2 Notr";
    homepage = "https://github.com/Try/OpenGothic";
    changelog = "https://github.com/Try/OpenGothic/releases/tag/opengothic-v${version}";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [mordrag];
  };
}
