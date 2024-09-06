{
  stdenv,
  lib,
  fetchzip,
  libsForQt5,
  autoPatchelfHook,
}:
stdenv.mkDerivation rec {
  pname = "spflashtool";
  version = "6.2228";

  src = fetchzip {
    url = "https://spflashtools.com/wp-content/uploads/SP_Flash_Tool_v${version}_Linux.zip";
    sha256 = "sha256-UDLHA9MATJwMJ91/yqUnsC0+lhZNNsL5E/baT2YotTg=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    libsForQt5.qt5.wrapQtAppsHook
  ];

  qtWrapperArgs = let
    runtimeLibs = with libsForQt5.qt5; [
      qtbase
      qtserialport
      qtxmlpatterns
    ];
  in "--set LD_LIBRARY_PATH ${lib.makeLibraryPath runtimeLibs}";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp $src/libflash.1.0.0.so $out/lib/libflash.1.0.0.so
    cp $src/libimagechecker.1.0.0.so $out/lib/libimagechecker.1.0.0.so
    cp $src/libsla_challenge.so $out/lib/libsla_challenge.so

    mkdir -p $out/bin
    cp $src/SPFlashToolV6 $out/bin/spflashtool
    chmod +x $out/bin/spflashtool

    runHook postInstall
  '';

  meta = with lib; {
    license = licenses.unfree;
    maintainers = with maintainers; [mordrag];
    description = "SP Flash Tool is an application to flash your MediaTek (MTK) SmartPhone.";
    platforms = platforms.linux;
  };
}
