#! /usr/bin/env nu

# source must not end with @

def find-paths [source] {
    if ($source | path basename | str ends-with '@') {
        return [$source]
    } else {
        let results = ls -a $source
        | where { |entry| $entry.type == dir }
        | each { |entry| find-paths $entry.name}

        let paths = if ($results | is-empty) {
            []
        } else {
            $results | reduce { |it, acc| $acc | append $it }
        }

        return $paths
    }
}

def load-paths [f, source, destination] {
    find-paths $source
    | each { |path|
        let relative = path relative-to $source
        let cleaned = $relative | str trim --char '@' --right

        let src = $source | path join $relative
        let dest = $destination | path join $cleaned

        do $f $src $dest
    }
}

def create-dir-inner [path, owner, group, mode, to_create] {
    if not ($path | path exists) {
        let parent = $path | path dirname
        let to_create = $to_create | prepend $path
        create-dir-inner $parent $owner $group $mode $to_create
    } else {
        $to_create
        | each { |path|
            mkdir $path
            chown $"($owner):($group)" $path
            chmod $mode $path
        }
    }
}

def create-dir [path, owner, group, mode] {
    # let mask = ((($"0o($mode)" | into int) bit-xor 0o777) | fmt).octal | str substring 2..
    # run-external "bash" "-c" "umask" $mask "&&" "mkdir" "-p" $path

    create-dir-inner $path $owner $group $mode []
}

def "main symlink" [source, destination, owner, group, mode] {
    let f = { |src, dest|
        if not ($dest | path exists) {
            let parent = $dest | path dirname

            if not ($parent | path exists) {
                create-dir $parent $owner $group $mode
            }
            ln -s $src $dest
        }
    }
    load-paths $f $source $destination

    return $"Successfully symlinked ($source) to ($destination)"
}

def "main mount" [source, destination, owner, group, mode] {
    let f = { |src, dest|
        if (mountpoint -q $dest | complete).exit_code != 0 {
            if not ($dest | path exists) {
                create-dir $dest $owner $group $mode
            }
            mount -o x-gvfs-hide,x-gvfs-trash --bind $src $dest
        }
    }
    load-paths $f $source $destination

    return $"Successfully mounted ($source) to ($destination)"
}

def main [] {

}
