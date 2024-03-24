{
  mkBottle,
  wine,
}:
mkBottle {
  inherit wine;
  name = "battle-net";
  packages = [
    "dxvk"
    "tahoma"
    "arial"
  ];
  registry = [
    {
      key = ''HKCU\Software\Wine\Drivers'';
      name = "Graphics";
      type = "REG_SZ";
      data = "wayland";
    }
    {
      key = ''HKCU\Software\Wine'';
      name = "Version";
      type = "REG_SZ";
      data = "win10";
    }
    {
      key = ''HKCU\Software\Wine\AppDefaults\BlizzardBrowser.exe'';
      name = "version";
      type = "REG_SZ";
      data = "win7";
    }
  ];
  workingDir = "drive_c/Program Files (x86)/Battle.net/";
  exe = "Battle.net.exe";
}
