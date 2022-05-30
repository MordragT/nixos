{ pkgs }:
with pkgs;

let
    desktop = makeDesktopItem {
        name = "spflashtool";
        exec = "spflashtool";
        comment = "SP Flash Tool is an application to flash your MediaTek (MTK) SmartPhone.";
        desktopName = "SP Flash Tool";
        genericName = "Anroid Flash Tool";
        icon = "spflashtool.png";
        categories = [];
    };
in
stdenv.mkDerivation rec {
    pname = "spflashtool";
    version = "6.2152";

    src = fetchurl {
        url = "https://spflashtools.com/wp-content/uploads/SP_Flash_Tool_v6.2152_Linux.zip";
        sha256 = "8a6b5c756fda89b00672b7c246ec1f04ef755afb4a2a35940dbd3d2932661324";
    };

    nativeBuildInputs = [
        unzip
    ];

    buildInputs = [
        libsForQt5.qt5.wrapQtAppsHook
        libsForQt5.qt5.qtserialport
        libsForQt5.qt5.qtxmlpatterns
    ];

    unpackPhase = ''
        unzip ${src}
    '';

    installPhase = ''
        runHook preInstall
        mkdir -p $out/bin $out/share/applications
        cp -r SP_Flash_Tool_v6.2152_Linux/* $out/

        chmod +x $out/SPFlashToolV6

        wrapProgram $out/SPFlashToolV6 \
        --prefix LD_LIBRARY_PATH : $out/lib

        ln -s $out/SPFlashToolV6 $out/bin/spflashtool
        
        # ln -s opt/spflashtool.png $out/share/pixmaps/spflashtool.png
        runHook postInstall
    '';

    postInstall = ''
        cp ${desktop}/share/applications/* $out/share/applications
    '';

  meta = with lib; {
    license = licenses.unfree;
    maintainers = with maintainers; [ mordrag ];
    description = "SP Flash Tool is an application to flash your MediaTek (MTK) SmartPhone.";
    platforms = platforms.linux;
  };
}