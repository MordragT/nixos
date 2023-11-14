{
  lib,
  stdenv,
  # writeScript,
  # makeDesktopItem,
  atk,
  at-spi2-atk,
  at-spi2-core,
  boost,
  cairo,
  fakeroot,
  gdk-pixbuf,
  glib,
  gtk3,
  libsoup,
  libgcc,
  libxml2,
  pango,
  ps,
  systemd,
  webkitgtk,
  zlib,
}:
# let
# desktopItem = makeDesktopItem {
#   desktopName = "Cisco Secure Client";
#   name = "cisco-secure-client";
#   exec = "${installDir}/bin/cisco-secure-client";
# };
# in
stdenv.mkDerivation {
  name = "cisco-secure-client";
  version = "5.0";

  src = /home/tom/Desktop/Mordrag/nixos/pkgs/cisco-secure-client/installer.tar.xz;

  # dontUnpack = true;

  buildInputs = [
    atk
    at-spi2-atk
    at-spi2-core
    boost
    cairo
    fakeroot
    gdk-pixbuf
    glib
    gtk3
    libsoup
    libxml2
    libgcc
    pango
    ps
    systemd
    webkitgtk
    zlib
  ];
  buildPhase = ''
    # not working due to embeded archive
    # substituteInPlace cisco-secure-client.sh \
    #   --replace "AC_INSTPREFIX=/opt/cisco/anyconnect" "AC_INSTPREFIX=$out/opt/cisco/anyconnect" \
    #   --replace "INSTPREFIX=/opt/cisco/secureclient" "INSTPREFIX=$out/opt/cisco/secureclient" \
    #   --replace "ROOTCERTSTORE=/opt/.cisco/certificates/ca" "ROOTCERTSTORE=$out/opt/.cisco/certificates/ca" \
    #   --replace 'SYSTEMD_CONF_DIR="/etc/systemd/system' 'SYSTEMD_CONF_DIR="$out/etc/systemd/system'

    sed -i '/AC_INSTPREFIX=/c AC_INSTPREFIX=$out/opt/cisco/anyconnect' cisco-secure-client.sh
    sed -i '/INSTPREFIX=/c INSTPREFIX=$out/opt/cisco/secureclient' cisco-secure-client.sh
    sed -i '/ROOTCERTSTORE=/c ROOTCERTSTORE=$out/opt/.cisco/certificates/ca' cisco-secure-client.sh
    sed -i '/SYSTEMD_CONF_DIR=/c SYSTEMD_CONF_DIR=$out/etc/systemd/system' cisco-secure-client.sh
    sed -i '/OURPROCS=/c OURPROCS=[]' cisco-secure-client.sh
    sed -i '/INSTALL=/c INSTALL=true' cisco-secure-client.sh
    sed -i '/ln -s/c echo' cisco-secure-client.sh
    sed -i '/ln -f -s/c echo' cisco-secure-client.sh
    sed -i '/\/usr/ $out\/usr"  cisco-secure-client.sh

    head -n300 cisco-secure-client.sh
    fakeroot sh cisco-secure-client.sh
  '';

  installPhase = ''
    ls
    mkdir -p "$out/bin"
    cp -r opt "$out"
    ln -s $out/cisco/secureclient/bin/vpnui $out/bin/cisco-secure-client
    chmod +x $out/bin/cisco-secure-client
  '';

  meta = with lib; {
    license = licenses.unfree;
    maintainers = with maintainers; [mordrag];
    description = "VPN and Endpoint Security Client";
    platforms = platforms.linux;
  };
}
