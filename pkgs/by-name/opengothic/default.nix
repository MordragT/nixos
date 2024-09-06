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
  steamCompatToolHook,
}:
stdenv.mkDerivation rec {
  pname = "opengothic";
  version = "unstable-2024-31-07";

  src = fetchFromGitHub {
    owner = "Try";
    repo = "OpenGothic";
    rev = "0c5366e72ee259600342810c426258feeab1047b";
    sha256 = "sha256-kLQ2DMxf+ojTzIl9VfDD6tp1wMEDYsOIMNOoMKQus/o=";
    fetchSubmodules = true;
  };

  outputs = ["out" "steamcompattool"];

  nativeBuildInputs = [
    cmake
    steamCompatToolHook
  ];

  compatLauncher = ''
    gothic_dir=$(dirname $(dirname "$1"))
    $out/bin/opengothic -g $gothic_dir $@ > /tmp/compat.log 2> /tmp/compat_err.log
  '';

  env.NIX_CFLAGS_COMPILE = toString ["-Wno-unused-but-set-variable"];

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
