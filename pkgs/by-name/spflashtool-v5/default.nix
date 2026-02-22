{
  stdenv,
  lib,
  fetchzip,
  autoPatchelfHook,
  fontconfig,
  freetype,
  glib,
  libXrender,
  libXext,
  libX11,
  libSM,
  libICE,
  zlib,
}:
stdenv.mkDerivation rec {
  pname = "spflashtool";
  version = "5.2032";

  src = fetchzip {
    url = "https://spflashtools.com/wp-content/uploads/SP_Flash_Tool_v${version}_Linux.zip";
    sha256 = "sha256-14L7d2avCd/RABW3TcbMSnjZxkYhJ/gJ68z6sG73HaI=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    fontconfig
    freetype
    glib
    libXrender
    libXext
    libX11
    libSM
    libICE
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r $src/lib/pkgconfig $out/lib/pkgconfig

    install -Dm0644 $src/lib/lib* $out/lib
    install -Dm0644 $src/libflashtool.so $out/lib/libflashtool.so
    install -Dm0644 $src/libflashtool.v1.so $out/lib/libflashtool.v1.so
    install -Dm0644 $src/libflashtoolEx.so $out/lib/libflashtoolEx.so
    install -Dm0644 $src/libsla_challenge.so $out/lib/libsla_challenge.so

    install -Dm0755 $src/flash_tool $out/bin/spflashtool
    install -Dm0644 $src/MTK_AllInOne_DA.bin $out/bin/MTK_AllInOne_DA.bin
    install -Dm0644 $src/console_mode.xsd $out/bin/console_mode.xsd
    install -Dm0644 $src/download_scene.ini $out/bin/download_scene.ini
    install -Dm0644 $src/key.ini $out/bin/key.ini
    install -Dm0644 $src/option.ini $out/bin/option.ini
    install -Dm0644 $src/platform.xml $out/bin/platform.xml
    install -Dm0644 $src/rb_without_scatter.xml $out/bin/rb_without_scatter.xml
    install -Dm0644 $src/storage_setting.xml $out/bin/storage_setting.xml
    install -Dm0644 $src/usb_setting.xml $out/bin/usb_setting.xml

    runHook postInstall
  '';

  meta = with lib; {
    license = licenses.unfree;
    maintainers = with maintainers; [ mordrag ];
    description = "SP Flash Tool is an application to flash your MediaTek (MTK) SmartPhone.";
    platforms = platforms.linux;
  };
}
