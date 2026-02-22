{
  stdenv,
  lib,
  fetchFromGitHub,
  wrapGAppsHook3,
  meson,
  ninja,
  pkg-config,
  vala,
  pantheon,
  gtk3,
  glib,
  gobject-introspection,
  libsoup_3,
  json-glib,
  libhandy,
  gst_all_1,
  lv2,
  lilv,
  pipewire,
  suil,
  fluidsynth,
  portmidi,
  libX11,
  desktop-file-utils,
}:
stdenv.mkDerivation {
  pname = "ensembles";
  version = "unstable-2022-09-10";

  src = fetchFromGitHub {
    owner = "ensemblesaw";
    repo = "ensembles-app";
    rev = "b16631a36882b6df9253a77d992eb78e9e0eedd2";
    sha256 = "pMg3xGMsqCHLDy5Fp2FK3cb9CMc606oNtZApREEfGQs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    desktop-file-utils
    vala
    pantheon.granite
    gtk3
    glib
    gobject-introspection
    libsoup_3
    json-glib
    libhandy
    gst_all_1.gstreamer
    lv2
    lilv
    pipewire
    suil
    fluidsynth
    portmidi
    libX11
  ];

  meta = with lib; {
    license = licenses.gpl3;
    maintainers = with maintainers; [ mordrag ];
    description = "A digital arranger workstation powered by FluidSynth";
    platforms = platforms.linux;
  };
}
