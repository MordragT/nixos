{
  writeShellApplication,
  makeDesktopItem,
  symlinkJoin,
  steam,
  cosmic-session,
  cosmic-osd,
}:
let
  script = writeShellApplication {
    name = "steamos-session-select";
    text = ''
      echo "$XDG_RUNTIME_DIR"
      SESSION_SWITCH_FILE="$XDG_RUNTIME_DIR/steamos-session/switch"
      mkdir -p "$(dirname "$SESSION_SWITCH_FILE")"

      if [ -f "$SESSION_SWITCH_FILE" ]; then
        rm "$SESSION_SWITCH_FILE"
        # systemctl --user start cosmic-session.service
        ${steam}/bin/steam -shutdown
        exec ${cosmic-session}/bin/cosmic-session
      else
        touch "$SESSION_SWITCH_FILE"
        # systemctl --user start steam-session.service
        ${cosmic-osd}/bin/cosmic-osd log-out
        # No need to execute steam-gamescope here, as it will be executed by greetd
        # exec steam-gamescope
      fi
    '';
  };
  desktopItem = makeDesktopItem {
    name = "steamos-session-select";
    desktopName = "Session Select";
    icon = "steam";
    exec = "${script}/bin/steamos-session-select";
  };
in
symlinkJoin {
  name = "steamos-cosmic-session-select";
  paths = [
    desktopItem
    script
  ];
}
