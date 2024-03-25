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
    rev = "a506c4656903d5754c21318f691939e239678b97";
    sha256 = "sha256-HswZVl3SXJE0UBRt23ZupUOjg/0Fly3MjO4B74cDBik=";
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
