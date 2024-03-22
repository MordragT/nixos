{
  pkgs,
  opengothic,
  ...
}: let
  mkCompatDerivation = {
    name,
    run,
  }:
    pkgs.nuenv.mkDerivation {
      inherit name;
      src = ./.;
      packages = [];
      debug = true;

      build = let
        launcher = ''
          #!/bin/bash

          waitforexitandrun() {
            ${run}
          }

          getnativepath() {
            echo "$STEAM_COMPAT_INSTALL_PATH"
          }

          getcompatpath() {
            echo "$STEAM_COMPAT_DATA_PATH"
          }

          case $1 in
          "waitforexitandrun")
            waitforexitandrun ''${@:2}
            ;;
          "getnativepath")
            getnativepath ''${@:2}
            ;;
          "getcompatpath")
            getcompatpath ''${@:2}
            ;;
          esac
        '';
      in ''
        mkdir $"($env.out)/bin"

        log "Create launcher script"
        (echo `${launcher}` | save $"($env.out)/bin/launcher.sh")
        ${pkgs.coreutils}/bin/chmod +x $"($env.out)/bin/launcher.sh"

        log "Create compatibilitytool.vdf"
        (echo `"compatibilitytools"
        {
          "compat_tools"
          {
            "${name}" // Internal name of this tool
            {
              "install_path" "."
              "display_name" "${name}"
              "from_oslist"  "windows"
              "to_oslist"    "linux"
            }
          }
        }` | save $"($env.out)/bin/compatibilitytool.vdf")

        log "Create toolmanifest.vdf"
        (echo `"manifest"
        {
          "version" "2"
          "commandline" "/launcher.sh %verb%"
          "use_sessions" "1"
        }` | save $"($env.out)/bin/toolmanifest.vdf")

      '';
    };
in {
  opengothic = mkCompatDerivation {
    name = "opengothic";
    run = ''
      gothic_dir=$(dirname $(dirname "$1"))
      ${opengothic}/bin/opengothic -g $gothic_dir $@ > /tmp/compat.log 2> /tmp/compat_err.log
    '';
  };
  proton-cachyos-bin = pkgs.callPackage ./proton-cachyos.nix {};
  proton-ge-bin = pkgs.proton-ge-bin;
  luxtorpeda = pkgs.luxtorpeda;
  steamtinkerlaunch = pkgs.steamtinkerlaunch;
}
