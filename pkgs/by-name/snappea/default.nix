{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  wayland,
  pipewire,
  glib,
  gst_all_1,
  libgbm,
  libglvnd,
  libxkbcommon,
  mesa,
  tesseract5, # Optional: for OCR
  gifski, # Optional: for optimized GIF-Export
}:
let
  version = "1.3.0";
in
rustPlatform.buildRustPackage {
  pname = "snappea";
  inherit version;

  src = fetchFromGitHub {
    owner = "hojjatabdollahi";
    repo = "snappea";
    rev = "v${version}";
    hash = "sha256-IFdXYAokiMrtDX+BEluAWBjZTLoSIVKFYdYVXdItyPs=";
  };

  cargoHash = "sha256-24c7FIzExEQBf/ei1uBgajcuVNq/QQWSweZ8K+11PoY=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    wayland
    pipewire
    glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libgbm
    libglvnd
    libxkbcommon
    mesa
  ];

  postInstall = ''
    for bin in "$out"/bin/*; do
      [ -x "$bin" ] || continue

      wrapProgram "$bin" \
        --prefix PATH : ${
          lib.makeBinPath [
            tesseract5
            gifski
          ]
        } \
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [
            wayland
            libglvnd
            libxkbcommon
            mesa
          ]
        }
    done
  '';

  meta = with lib; {
    description = "Screenshot- und Screen-Recording-Tool mit Annotationsfunktion für COSMIC DE";
    homepage = "https://github.com/hojjatabdollahi/snappea";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "snappea";
  };
}
