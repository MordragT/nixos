{
  lib,
  stdenv,
  fetchFromGitHub,
  addOpenGLRunpath,
  cmake,
  alsa-lib,
  glslang,
  libglvnd,
  vulkan-headers,
  xorg,
}:
stdenv.mkDerivation rec {
  pname = "opengothic";
  version = "1.0.2207";

  src = fetchFromGitHub {
    owner = "Try";
    repo = "OpenGothic";
    rev = "master";
    sha256 = "sha256-31EeATIwrjAsu2DOOl4Uwm5bvCJzBXSSpBXjVPMf/Y4=";
    fetchSubmodules = true;
  };

  # > CMake Error at CMakeLists.txt:138 (target_compile_options):
  # > Cannot specify compile options for target "LinearMath" which is not built
  # > by this project.

  nativeBuildInputs = [
    cmake
    addOpenGLRunpath
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DCMAKE_BUILD_TYPE:STRING=RelWithDebInfo"
  ];

  buildInputs = [
    alsa-lib
    glslang
    libglvnd
    vulkan-headers
    xorg.libX11
    xorg.libXcursor
  ];

  meta = with lib; {
    broken = true;
    description = "Reimplementation of Gothic 2 Notr";
    homepage = "https://github.com/Try/OpenGothic";
    changelog = "https://github.com/Try/OpenGothic/releases/tag/opengothic-v${version}";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [mordrag];
  };
}
