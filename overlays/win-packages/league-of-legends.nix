{
  lib,
  symlinkJoin,
  mkBottle,
  makeDesktopItem,
  wine,
}: let
  name = "league-of-legends";
  bottle = mkBottle {
    inherit name wine;
    packages = [
      "dxvk"
    ];
    registry = [
      {
        path = ''HKCU\Software\Wine\Drivers'';
        key = "Graphics";
        type = "REG_SZ";
        value = "wayland";
      }
    ];
    workingDir = "drive_c/Riot Games/League of Legends/";
    exe = "LeagueClient.exe";
  };
  icon = builtins.fetchurl {
    url = "https://cdn2.steamgriddb.com/icon/d10ddbe86fe1df4e50c91d66087cbc6a.png";
    name = "${name}.png";
    sha256 = "0vsniv15iql36063h511479sxna98n9v6carp7xn5lhi63dn16mv";
  };
  desktop = makeDesktopItem {
    inherit name icon;
    desktopName = "League of Legends";
    exec = "${bottle}/bin/${name}";
    categories = ["Game"];
  };
in
  symlinkJoin {
    inherit name;
    paths = [desktop bottle];

    meta = {
      description = "League of Legends is a multiplayer online battle arena (MOBA) game in which the player controls a character with a set of unique abilities from an isometric perspective.";
      homepage = "https://www.leagueoflegends.com/";
      license = lib.licenses.unfree;
      maintainers = with lib.maintainers; [mordrag];
      platforms = ["x86_64-linux"];
    };
  }
