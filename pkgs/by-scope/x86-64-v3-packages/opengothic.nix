{
  lib,
  env,
  fetchFromGitHub,
  cmake,
  alsa-lib,
  glslang,
  libglvnd,
  vulkan-headers,
  vulkan-loader,
  xorg,
}:
env.mkDerivation rec {
  pname = "opengothic";
  version = "master";

  src = fetchFromGitHub {
    owner = "Try";
    repo = "OpenGothic";
    rev = "008fec3124dd1cb2c5a6499c4a57aab3195d13fb";
    sha256 = "sha256-29VwLjKdI0OjiW1rRCuAR1DutMyBkkowrKQ3SKGITD8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  env.NIX_CFLAGS_COMPILE = ["-Wno-unused-but-set-variable"];

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
