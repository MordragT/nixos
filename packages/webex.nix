{ pkgs }:
with pkgs;

stdenv.mkDerivation {
  pname = "webex";
  version = "41.10.0.20371-j1";

  src = fetchurl {
    # Official link: https://binaries.webex.com/WebexDesktop-Ubuntu-Official-Package/Webex.deb
    # New versions get uploaded to same link, so lock url for this version in archive.org
    #url = "https://web.archive.org/web/20210529010325/https://binaries.webex.com/WebexDesktop-Ubuntu-Official-Package/Webex.deb";
    url = "https://binaries.webex.com/WebexDesktop-Ubuntu-Official-Package/Webex.deb";
    sha256 = "jUSWwXQK1Wh73sInI18w/QKSVrBLR981+LJqdBvdW+I=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    mesa.dev # for libgbm
    libGL
    xorg.libX11
    xorg.libXdamage
    xorg.libXfixes
    xorg.libXcomposite
    xorg.libXrandr
    xorg.libXScrnSaver
    cups
    libxkbcommon
    libsecret
    xorg.libxcb
    xorg.xcbutilwm
    xorg.xcbutilrenderutil
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    libdrm
    xorg.libxshmfence
    fontconfig
    nss
    wayland
    udev
    dbus
    glib
    gdk-pixbuf
    gtk3
    libpulseaudio
    pango
    cairo
    alsaLib
    at-spi2-core
    at-spi2-atk
    harfbuzz
  ];

  dontBuild = true;

  unpackPhase = ''
    dpkg-deb -R $src .
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/applications
    cp -r opt $out/
    wrapProgram $out/opt/Webex/bin/CiscoCollabHost \
      --prefix LD_LIBRARY_PATH : $out/opt/Webex/lib
    ln -s $out/opt/Webex/bin/CiscoCollabHost $out/bin/webex
    ln -s $out/opt/Webex/bin/sparlogosmall.png $out/bin/sparklogosmall.png
    substitute $out/opt/Webex/bin/webex.desktop $out/share/applications/webex.desktop \
      --replace /opt/Webex/bin/ $out/opt/Webex/bin/
    runHook postInstall
  '';

  meta = with lib; {
    license = licenses.unfree;
    maintainers = with maintainers; [ mordrag ];
    description = "Webex for Linux";
    platforms = platforms.linux;
  };
}
