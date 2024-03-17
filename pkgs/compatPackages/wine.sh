    #!/usr/bin/env bash

    waitforexitandrun() {
      WINE_PREFIX=${STEAM_COMPAT_DATA_PATH}/pfx
      [ ! -d "$WINE_PREFIX" ] && mkdir $WINE_PREFIX
      wine $@ > /tmp/compat.log 2> /tmp/compat_err.log
    }

    getnativepath() {
      echo "$STEAM_COMPAT_INSTALL_PATH"
    }

    getcompatpath() {
      echo "$STEAM_COMPAT_DATA_PATH"
    }

    case $1 in
    "waitforexitandrun")
      waitforexitandrun ${@:2}
      ;;
    "getnativepath")
      getnativepath ${@:2}
      ;;
    "getcompatpath")
      getcompatpath ${@:2}
      ;;
     esac