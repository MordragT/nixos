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
      path = ''HKCU\Software\Wine\Drivers'';
      key = "Graphics";
      type = "REG_SZ";
      value = "wayland";
    }
    {
      path = ''HKCU\Software\Wine'';
      key = "Version";
      type = "REG_SZ";
      value = "win10";
    }
    {
      path = ''HKCU\Software\Wine\AppDefaults\BlizzardBrowser.exe'';
      key = "version";
      type = "REG_SZ";
      value = "win7";
    }
    {
      path = ''HKCU\Software\Wine\DXVA2'';
      key = "backend";
      type = "REG_SZ";
      value = "va";
    }
  ];
  workingDir = "drive_c/Program Files/Battle.net/";
  exe = "Battle.net.exe";
}
