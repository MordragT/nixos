const dcs_name = ".dcs"
const config_name = "config.toml"
const objects_name = "objects"

export def init [remote destination force=false] {
    let root = root-path

    let dcs_path = dcs-path $root
    if $force {
        rm -r $dcs_path
    }
    mkdir $dcs_path
    mkdir (objects-path $root)
    let config = {
        remote: $remote
        destination: $destination
        # table must not be empty apparently
        objects: [[root]; ["/"]]
    }
    $config | to toml | save (config-path $root)
}

export def root-path [] {
    is-git
    let root = git rev-parse --show-toplevel
    $root
}

export def dcs-path [root] {
    $root | path join $dcs_name
}

export def objects-path [root] {
    [ $root $dcs_name $objects_name ] | path join
}

export def config-path [root] {
    [ $root $dcs_name $config_name ] | path join
}

export def update-config [root, field, replacement] {
    let path = config-path $root
    if not ($path | path exists) {
        error make {
            msg: "Data control is not initialized"
            help: "Initialize with 'dcs init <remote> <destination>"
        }
    } else {
        let config = open $path | update $field $replacement
        $config | to toml | save -f $path
    }
}

export def add-object [root, path] {
    let absolute = pwd | path join $path
    if not ($absolute | path exists) {
        error make {
            msg: "Specified path does not exist"
            help: "Cannot add a file or directory that does not exist"
        }
    }

    let hash = match ($absolute | path type) {
        "file" => {
            open $absolute | hash md5
        }
        _ => {
            error make {
                msg: "Only files supported"
            }
        }
    }
    let relative = $absolute | path relative-to $root
    let object_path = [(objects-path $root) $hash $relative] | path join
    
    mkdir ($object_path | path dirname)
    ln -s $absolute $object_path

    update-config $root objects { |config|
        $config.objects | upsert $relative $hash
    }
}

def is-git [] {
    let output = do { git rev-parse --is-inside-work-tree } | complete
    if $output.exit_code != 0 {
        error make {
            msg: "Not inside a git repository"
            help: "Initialize a git repository before running dcs commands"
        }
    }
}