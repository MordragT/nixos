{
  lib,
  buildFHSUserEnv,
  # writeScript,
  makeDesktopItem,
}: let
  installDir = "/home/tom/Programs/Applications/cisco-secure-client";
  desktopItem = makeDesktopItem {
    desktopName = "Cisco Secure Client";
    name = "cisco-secure-client";
    exec = "${installDir}/bin/cisco-secure-client";
  };
in
  buildFHSUserEnv {
    name = "cisco-secure-client-shell";
    targetPkgs = pkgs: (with pkgs; [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      atk
      cairo
      cups
      dbus
      expat
      fontconfig
      freetype
      glib
      gdk-pixbuf
      gtk3
      harfbuzz
      lshw
      mesa
      nspr
      nss
      pango
      zlib
      libdrm
      libgcrypt
      libglvnd
      libkrb5
      libpulseaudio
      libsecret
      udev
      tbb
      wayland
      (with xorg; [
        libxcb
        libxkbcommon
        libxcrypt-legacy
        libX11
        libXcomposite
        libXcursor
        libXdamage
        libXext
        libXfixes
        libXi
        libXrandr
        libXrender
        libXtst
        libxshmfence
        xcbutil
        xcbutilimage
        libXScrnSaver
        xcbutilkeysyms
        xcbutilrenderutil
        xcbutilwm
      ])
    ]);

    extraInstallCommands = ''
      install -Dm644 ${desktopItem}/share/applications/cisco-secure-client.desktop $out/share/applications/cisco-secure-client.desktop
    '';

    runScript = "${installDir}/bin/cisco-secure-client";

    meta = with lib; {
      license = licenses.unfree;
      maintainers = with maintainers; [mordrag];
      description = "VPN and Endpoint Security Client";
      platforms = platforms.linux;
    };
  }
