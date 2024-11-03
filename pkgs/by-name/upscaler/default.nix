{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchPypi,
  meson,
  ninja,
  wrapGAppsHook4,
  gobject-introspection,
  desktop-file-utils,
  blueprint-compiler,
  python3,
  gettext,
  glib,
  gtk4,
  libadwaita,
  upscayl-ncnn,
}: let
  vulkan = python3.pkgs.buildPythonPackage rec {
    pname = "vulkan";
    version = "1.3.275.1";
    format = "wheel";

    src = fetchPypi {
      inherit pname version format;
      sha256 = "sha256-4eDd9X06fRn3nr8eGSsg29N4FysCfK1PSV2WG1FAlYY=";
      python = "py3";
      dist = "py3";
    };

    build-system = with python3.pkgs; [
      setuptools
      wheel
    ];

    dependencies = with python3.pkgs; [
      pysdl2
      jinja2
      inflection
      xmltodict
      cffi
    ];
  };
in
  stdenv.mkDerivation rec {
    pname = "upscaler";
    version = "1.4.0";

    src = fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "World";
      repo = "Upscaler";
      rev = version;
      hash = "sha256-Dy8tykIbK5o0XulurG+TxORZZSxfRe5Kjh6aGpsh+0Y=";
    };

    dontWrapGApps = true;

    nativeBuildInputs = [
      meson
      ninja
      wrapGAppsHook4
      gobject-introspection
      desktop-file-utils
      blueprint-compiler
      (python3.withPackages (ps:
        with ps; [
          pygobject3
          pygobject-stubs
          pillow
          vulkan
        ]))
    ];

    buildInputs = [
      gettext
      glib
      gtk4
      libadwaita
    ];

    preFixup = ''
      gappsWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [upscayl-ncnn]}")
      wrapGApp $out/bin/upscaler
    '';

    meta = with lib; {
      description = "Upscale and enhance images";
      homepage = "https://gitlab.gnome.org/World/Upscaler";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [mordrag];
      mainProgram = "upscaler";
      platforms = platforms.all;
    };
  }
