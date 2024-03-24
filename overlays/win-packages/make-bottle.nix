{
  lib,
  nuenv,
  winetricks,
}: {
  name,
  wine,
  wineFlags ? [],
  packages ? [],
  registry ? [],
  exe,
  workingDir ? "drive_c",
  prefix ? ".local/share/prefixes/${name}",
  linkHome ? false,
}: let
  flags = lib.concatStringsSep " " wineFlags;
  tricks = lib.concatStringsSep " " packages;
  tricksCmd =
    if (lib.length packages) > 0
    then "${winetricks}/bin/winetricks ${tricks}"
    else "";
  regAdd = entry: "${wine}/bin/wine reg add ${entry.path} /v ${entry.key} /t ${entry.type} /d ${entry.value}\n";
  regedit = lib.concatMapStrings regAdd registry;
  lnHome =
    if linkHome
    then ''
      let user_dir = ($env.WINEPREFIX | path join drive_c users $env.USER)
      rm -rf $user_dir
      ln -s $env.HOME $user_dir
    ''
    else "";
in
  nuenv.writeScriptBin {
    inherit name;
    script = ''
      let prefix = $env.HOME | path join "${prefix}"

      $env.WINE = ${wine}/bin/wine
      $env.WINESERVER = ${wine}/bin/wineserver
      # $env.WINEARCH = "win64"
      $env.WINEPREFIX = $prefix

      def main [] {
        if ($prefix | path exists) {
          run
        } else {
          setup $env.SETUP
        }
      }

      def "main setup" [exe] {
        setup $exe
      }

      def "main run" [] {
        run
      }

      def setup [exe] {
        rm -rf $prefix
        mkdir $prefix

        ${wine}/bin/wineboot
        ${wine}/bin/wineserver -w

        ${tricksCmd}
        ${lnHome}

        ${regedit}
        ${wine}/bin/wineserver -w

        ${wine}/bin/wine $exe
        ${wine}/bin/wineserver -w
      }

      def run [] {
        ${wine}/bin/wine ${flags} ($prefix | path join "${workingDir}" "${exe}")
        ${wine}/bin wineserver -w
      }
    '';
  }
