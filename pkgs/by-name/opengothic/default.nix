{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
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
  version = "unstable-2025-24-02";

  src = fetchFromGitHub {
    owner = "Try";
    repo = "OpenGothic";
    rev = "9f8e47965d3370dae745497255a828ea824b3c0e";
    sha256 = "sha256-galZq7CycdhSOuxk9ccbYakWmfyEIsFYVMLpZL4g1aM=";
    fetchSubmodules = true;
  };

  outputs = ["out" "steamcompattool"];

  nativeBuildInputs = [
    cmake
    makeWrapper
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
    wrapProgram $out/bin/opengothic \
      --set LD_PRELOAD "${lib.getLib alsa-lib}/lib/libasound.so.2"
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
