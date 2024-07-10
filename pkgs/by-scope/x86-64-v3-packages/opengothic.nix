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
  version = "unstable-2024-10-06";

  src = fetchFromGitHub {
    owner = "Try";
    repo = "OpenGothic";
    rev = "d1d28326d209f7bc47edbe74da64f3292266d7fb";
    sha256 = "sha256-IkIHx3aHP1fJ+T/AncDCETFGFt9NpZmlK+5CNwEu+wM=";
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
