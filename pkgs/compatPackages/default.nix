{pkgs, ...}: let
  compat-wrapper = {
    name,
    src,
    packages,
  }:
    pkgs.nuenv.mkDerivation {
      inherit name src packages;
      debug = true;

      build = ''
        mkdir -p $"($env.out)/bin"
        cp $env.src $"($env.out)/bin/launcher"

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

        (echo `"manifest"
        {
          "version" "2"
          "commandline" "/launcher %verb%"
          "use_sessions" "1"
        }` | save $"($env.out)/bin/toolmanifest.vdf")

      '';
    };
in {
  wine-unstable = compat-wrapper {
    name = "wine-unstable";
    src = ./wine.sh;
    packages = [pkgs.wine64Packages.unstableFull];
  };
}
