{
  lib,
  nuenv,
  winetricks,
  dxvk,
}: {
  mkBottle = {
    name,
    wine,
    wineArch ? 32,
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
    regAdd = entry: "^$env.WINE reg add ${entry.path} /v ${entry.key} /t ${entry.type} /d ${entry.value}\n";
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
        $env.WINE = ${wine}/bin/wine
        $env.WINESERVER = ${wine}/bin/wineserver
        $env.WINEBOOT = ${wine}/bin/wineboot
        $env.WINEARCH = "win${toString wineArch}"
        $env.WINEPREFIX = ($env.HOME | path join "${prefix}")
        $env.PATH = ($env.PATH | append ${lib.makeBinPath [wine dxvk]})

        def main [] {
          if ($env.WINEPREFIX | path exists) {
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
          rm -rf $env.WINEPREFIX
          mkdir $env.WINEPREFIX

          ^$env.WINEBOOT
          ^$env.WINESERVER -w

          ${tricksCmd}
          ${lnHome}

          ${regedit}
          ^$env.WINESERVER -w

          ^$env.WINE $exe
          ^$env.WINESERVER -w
        }

        def run [] {
          ^$env.WINE ${flags} ($env.WINEPREFIX | path join "${workingDir}" "${exe}")
          ^$env.WINESERVER -w
        }
      '';
    };
}
