{
  lib,
  stdenv,
  wineWowPackages,
  dxvk,
  nuenv,
  fuse-overlayfs,
}: {
  name,
  directory,
  wine-env,
  pre-cmd ? "",
  cmd,
  post-cmd ? "",
}:
nuenv.writeScriptBin {
  inherit name;
  script = ''
    use std

    $env.WINEARCH = "${wine-env.wineArch}"
    $env.WINEESYNC = 1
    $env.WINEPREFIX = "${directory}/mount/"

    const app_dir = "${directory}/app/"
    const work_dir = "${directory}/work/"

    std path add "${wine-env.wine}/bin"

    def main [] {
      if ($app_dir | path exists) {
        run
      } else {
        setup $env.SETUP
      }
    }

    def "main run" [] {
      run
    }

    def "main setup" [exe] {
      setup $exe
    }

    def "main cfg" [] {
      init
      winecfg
      deinit
    }

    def "main regedit" [] {
      init
      regedit
      deinit
    }

    def "main console" [] {
      init
      wineconsole
      deinit
    }

    # def init [] {
    #   mkdir $work_dir $env.WINEPREFIX

    #   sudo mount -t overlay overlay -o lowerdir=${wine-env},upperdir=($app_dir),workdir=($work_dir) $env.WINEPREFIX
    # }

    # def deinit [] {
    #   wineserver -w
    #   sudo umount $env.WINEPREFIX
    #   rm -r $work_dir $env.WINEPREFIX
    # }


    def init [] {
      mkdir $work_dir $env.WINEPREFIX

      # let system_reg = [ $app_dir "system.reg" ] | path join
      # if not ($system_reg | path exists) {
      #   cp ${wine-env}/system.reg $system_reg
      #   chown
      #   chmod -R gu+w $system_reg
      # }

      # let user_reg = [ $app_dir "user.reg" ] | path join
      # if not ($user_reg | path exists) {
      #   cp ${wine-env}/user.reg $user_reg
      #   chmod -R gu+w $user_reg
      # }

      # let user_def_reg = [ $app_dir "userdef.reg" ] | path join
      # if not ($user_def_reg | path exists) {
      #   cp ${wine-env}/userdef.reg $user_def_reg
      #   chmod -R gu+w $user_def_reg
      # }

      # -o $'uidmapping=0:(id -u):1:1:1:65536,gidmapping=0:(id -g):1:1:1:65536'

      (${fuse-overlayfs}/bin/fuse-overlayfs
        -o lowerdir=${wine-env}
        -o upperdir=($app_dir)
        -o workdir=($work_dir)
        -o squash_to_uid=(id -u)
        -o squash_to_gid=(id -g)
        $env.WINEPREFIX)

      sudo chmod -R u=rwX,go=rX $env.WINEPREFIX/*
    }

    def deinit [] {
      wineserver -k
      fusermount3 -u $env.WINEPREFIX
      rm -r $work_dir $env.WINEPREFIX
    }

    def setup [exe] {
      if ($app_dir | path exists) {
        print "This setup will delete the existing files. Proceed ? (y, n)"
        let answer = (input --numchar 1)
        if (($answer == "y") or ($answer == "Y")) {
          rm -r $app_dir
        } else {
          return
        }
      }

      mkdir $app_dir

      init
      wine $exe
      deinit
    }

    def run [] {
      init
      ${pre-cmd} ^wine ${directory}/mount/${cmd} ${post-cmd}
      deinit
    }
  '';
}
