{
  writeShellApplication,
  bash,
  systemd,
  coreutils,
  dbus,
  cosmic-session,
  makeDesktopItem,
  symlinkJoin,
}: let
  start = writeShellApplication {
    name = "start-cosmic-ext-niri";
    runtimeInputs = [systemd dbus cosmic-session bash coreutils]; # TODO niri ?
    text = ''
      set -e
      export XDG_CURRENT_DESKTOP="''${XDG_CURRENT_DESKTOP:=cosmic}"
      export XDG_SESSION_TYPE="''${XDG_SESSION_TYPE:=wayland}"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export GDK_BACKEND=wayland,x11
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM="wayland;xcb"
      export QT_AUTO_SCREEN_SCALE_FACTOR=1
      export QT_ENABLE_HIGHDPI_SCALING=1
      export DCONF_PROFILE=cosmic
      systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP DCONF_PROFILE
      exec dbus-run-session -- cosmic-session niri
    '';
  };
  desktop = makeDesktopItem {
    name = "cosmic-ext-niri";
    desktopName = "COSMIC Niri";
    comment = "This session logs you into the COSMIC desktop on niri";
    exec = "${start}/bin/start-cosmic-ext-niri";
    destination = "/share/wayland-sessions";
  };
in
  symlinkJoin {
    name = "cosmic-ext-niri";
    version = "0.1.0";
    paths = [
      desktop
      start
    ];
    passthru.providedSessions = ["cosmic-ext-niri"];
  }
