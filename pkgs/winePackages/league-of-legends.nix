{
  lib,
  nuenv,
  makeDesktopItem,
  symlinkJoin,
  wine-lol-bin,
  steam,
  name ? "league-of-legends",
}: let
  icon = builtins.fetchurl {
    url = "https://cdn2.steamgriddb.com/icon/d10ddbe86fe1df4e50c91d66087cbc6a.png";
    name = "${name}.png";
    sha256 = "0vsniv15iql36063h511479sxna98n9v6carp7xn5lhi63dn16mv";
  };
  steam-run =
    (
      steam.override {
        extraLibraries = pkgs:
          with pkgs; [
            wayland-protocols
            gamemode
            wine-lol-bin
          ];
      }
    )
    .run;
  script = nuenv.writeScriptBin {
    inherit name;
    script = ''
      let prefix = $env.HOME | path join .local share games ${name}

      # TODO wine64 seems to call wine32 which cannot use the 64-bit nix-ld linker
      # causing running wine without some sort of fhs env or autoPatchelf to fail
      def wine [...args] {
        (
          WINEPREFIX=$prefix
          ${steam-run}/bin/steam-run
          gamemoderun
          wine
          ...$args
        )
      }

      def main [] {
        wine ($prefix | path join drive_c "Riot Games" "League of Legends" LeagueClient.exe)
      }

      def "main install" [setup] {
        mkdir $prefix
        # wine regedit ${./wayland.reg}
        wine $setup
      }
    '';
  };
  desktop = makeDesktopItem {
    inherit name icon;
    desktopName = "League of Legends";
    exec = "${script}/bin/${name}";
    categories = ["Game"];
  };
in
  symlinkJoin {
    inherit name;
    paths = [desktop script];

    meta = {
      description = "League of Legends is a multiplayer online battle arena (MOBA) game in which the player controls a character with a set of unique abilities from an isometric perspective.";
      homepage = "https://www.leagueoflegends.com/";
      license = lib.licenses.unfree;
      maintainers = with lib.maintainers; [mordrag];
      platforms = ["x86_64-linux"];
    };
  }
