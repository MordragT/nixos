{
  makeDesktopItem,
  chromium,
}:
{
  name,
  desktopName,
  app,
  ...
}@attrs:
let
  args = removeAttrs attrs [
    "name"
    "desktopName"
    "app"
    "exec"
  ];
in
# use lswt to find out wayland toplevels ("windows")
# startupWMClass = "chrome-${url without http:// prefix}__-Default"
makeDesktopItem (
  {
    inherit name desktopName;
    exec = "${chromium}/bin/chromium --app=${app}";
  }
  // args
)
