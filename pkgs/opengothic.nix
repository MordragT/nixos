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
  version = "1.0.2207";

  src = fetchFromGitHub {
    owner = "Try";
    repo = "OpenGothic";
    rev = "e2235f6936f317ca4f30d2b11f929cbbe38ebcf4";
    sha256 = "sha256-NNGCo5r7SJOc0Z8+y2MNiw3VOVK5M+ypP/tEZ1dwhD8=";
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
