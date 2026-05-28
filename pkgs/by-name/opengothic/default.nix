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
  libX11,
  libXcursor,
  steamCompatToolHook,
}:
let
  version = "0.92";
in
stdenv.mkDerivation {
  pname = "opengothic";
  inherit version;

  src = fetchFromGitHub {
    owner = "Try";
    repo = "OpenGothic";
    rev = "v${version}";
    sha256 = "sha256-6HCBmSjzV3nVDuD/7im6NtWLkDu+V+in2lUloEhp3Cc=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "steamcompattool"
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    steamCompatToolHook
  ];

  compatLauncher = ''
    gothic_dir=$(dirname $(dirname "$1"))
    $out/bin/opengothic -g $gothic_dir $@ > /tmp/compat.log 2> /tmp/compat_err.log
  '';

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-unused-but-set-variable" ];

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
    libX11
    libXcursor
  ];

  postInstall = ''
    mv opengothic/lib* $out/lib/
    mv $out/bin/Gothic2Notr $out/bin/opengothic
    wrapProgram $out/bin/opengothic \
      --set LD_PRELOAD "${lib.getLib alsa-lib}/lib/libasound.so.2"
  '';

  meta = with lib; {
    broken = true;
    description = "Reimplementation of Gothic 2 Notr";
    homepage = "https://github.com/Try/OpenGothic";
    changelog = "https://github.com/Try/OpenGothic/releases/tag/opengothic-v${version}";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ mordrag ];
  };
}
