steamCompatToolHook() {
    if [ -z "${steamcompattool}" ]; then
        echo "Error: Output steamcompattool must be present"
        exit 1
    fi

    if [ -z "${compatLauncher}" ]; then
        echo "Error: Steam compat tool launcher variable `compatLauncher` must be set"
        exit 1
    fi

    mkdir $steamcompattool

    cat <<EOF > $steamcompattool/launcher.sh
#!/bin/bash
waitforexitandrun() {
    ${compatLauncher}
}

getnativepath() {
    echo "\${STEAM_COMPAT_INSTALL_PATH}"
}

getcompatpath() {
    echo "\${STEAM_COMPAT_DATA_PATH}"
}

case \$1 in
"waitforexitandrun")
    waitforexitandrun "\${@:2}"
    ;;
"getnativepath")
    getnativepath "\${@:2}"
    ;;
"getcompatpath")
    getcompatpath "\${@:2}"
    ;;
esac
EOF

    chmod +x $steamcompattool/launcher.sh

    cat <<EOF > $steamcompattool/compatibilitytool.vdf
"compatibilitytools"
{
    "compat_tools"
    {
        ${name} // Internal name of this tool
        {
            "install_path" "."
            "display_name" ${name}
            "from_oslist"  "windows"
            "to_oslist"    "linux"
        }
    }
}
EOF

    cat <<EOF > $steamcompattool/toolmanifest.vdf
"manifest"
{
    "version" "2"
    "commandline" "/launcher.sh %verb%"
    "use_sessions" "1"
}
EOF

}

postInstallHooks+=(steamCompatToolHook)
