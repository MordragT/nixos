{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, libxcb
, cmake
, wrapQtAppsHook
, qtbase
, qtdeclarative
, qtquickcontrols
, qtquickcontrols2
, ffmpeg-full
, gst_all_1
, libpulseaudio
, alsa-lib
, jack2
, v4l-utils
, kmod
, polkit
}:
stdenv.mkDerivation rec {
  pname = "webcamoid";
  version = "master";

  src = fetchFromGitHub {
    sha256 = "JmItbJmEMmDirIaOV4XKF43/PrCGwHB4MHB+SlGMy8I=";
    rev = "8a5f394805c08796c9acfc5504a1603b283aae39";
    repo = "webcamoid";
    owner = "webcamoid";
  };

  buildInputs = [
    libxcb
    qtbase
    qtdeclarative
    qtquickcontrols
    qtquickcontrols2
    ffmpeg-full
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    alsa-lib
    libpulseaudio
    jack2
    v4l-utils
    kmod.dev
  ];

  nativeBuildInputs = [ pkg-config cmake wrapQtAppsHook ];

  #dontWrapQtApps = true;

  cmakeFlags = [
    "-DEXTRA_SUDOER_TOOL_DIR=${polkit.bin}/bin/"
  ];

  preConfigure = ''
    substituteInPlace libAvKys/Plugins/VirtualCamera/src/akvcam/src/vcamak.cpp --replace '"sh"' '"/bin/sh"'
    substituteInPlace libAvKys/Plugins/VirtualCamera/src/v4l2lb/src/vcamv4l2lb.cpp --replace '"sh"' '"/bin/sh"'
  '';

  meta = with lib; {
    description = "Webcam Capture Software";
    longDescription = "Webcamoid is a full featured and multiplatform webcam suite.";
    homepage = "https://github.com/webcamoid/webcamoid/";
    license = [ licenses.gpl3Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ mordrag ];
  };
}
