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
  # broken some problem with ZenKit and phoenix include dir
  # version = "unstable-2025-13-09";
  version = "unstable-2025-27-03";

  src = fetchFromGitHub {
    owner = "Try";
    repo = "OpenGothic";
    # rev = "a47ed54f8ae9ed6665bcc4c5764e044421184e8f";
    # sha256 = "sha256-wNeNI1zU5+sheRcnQrpfRvINfowt2HlMCHoRzg2L30g=";
    rev = "379bef748420df5bda142251b95d829e4f6cfed3";
    sha256 = "sha256-RkIuP283kEKugENQcCp9LOo4jyLdCSvocoTz2N2qmzg=";
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
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
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
