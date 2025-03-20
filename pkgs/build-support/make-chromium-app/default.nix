{
  makeDesktopItem,
  chromium,
}: {
  name,
  desktopName,
  app,
  ...
} @ attrs: let
  args = removeAttrs attrs ["name" "desktopName" "app" "exec"];
in
  makeDesktopItem ({
      inherit name desktopName;
      exec = "${chromium}/bin/chromium --app=${app}";
    }
    // args)
