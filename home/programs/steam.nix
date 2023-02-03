{ fetchFromGitHub, stdenv, config, lib, ... }:
with builtins;
let
  theme = stdenv.mkDerivation rec {
    name = "adwaita-for-steam";

    src = fetchFromGitHub {
      owner = "tkashkin";
      repo = "Adwaita-for-Steam";
      rev = "7d293ed7b25e2cd10d84b278e64ac2ae0737aabc";
      sha256 = "l4BoB7EcNDLt6QDDMfVfl8JH0vkDWoPsborT0/9hYuM=";
    };

    installPhase = ''
      mkdir -p $out
      mkdir -p $out/resource/
      touch $out/resource/webkit.css

      cp -r $src/Adwaita/* $out/

      for f in $src/web_themes/base/*
      do
        cat "$f" >> $out/resource/webkit.css
      done

      for f in $src/web_themes/full/*
      do
        cat "$f" >> $out/resource/webkit.css
      done
    '';
  };
in
{
  # does not work because steam cannot read symlinks
  # xdg.dataFile."Steam/skins/Adwaita".source = theme;

  home.activation = {
    copySteamAdwaitaSkin = lib.hm.dag.entryAfter
      [ "writeBoundary" ]
      ''
        if [ ! -d ${config.xdg.dataHome}/Steam/skins ]; then
          mkdir -p ${config.xdg.dataHome}/Steam/skins
        fi
        # Delete the directory to copy again, if src was updated
        if [ -d ${config.xdg.dataHome}/Steam/skins/adwaita ]; then
          rm -rf ${config.xdg.dataHome}/Steam/skins/adwaita
        fi
        cp -r ${theme} ${config.xdg.dataHome}/Steam/skins/adwaita
        chmod -R +w ${config.xdg.dataHome}/Steam/skins/adwaita
      '';
  };
}
