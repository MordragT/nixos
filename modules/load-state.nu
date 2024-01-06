#! /usr/bin/env nu

# source must not start with @

def find-paths [source] {
    if ($source | path basename | str starts-with "@") {
        return [$source]
    } else {
        let results = ls -a $source
        | filter { |entry| $entry.type == dir }
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
    let left = if ($source | str ends-with "/") {
        $source | str length
    } else {
        # skip leading /
        ($source | str length) + 1
    }

    let relative_paths = find-paths $source
    | each { |path| $path | str substring $left.. }

    $relative_paths
    | each { |rel| 
        let cleaned = $rel | str replace '@' ''

        let src = $source | path join $rel
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
        let parent = $dest | path dirname

        if not ($parent | path exists) {
            create-dir $parent $owner $group $mode
        }
        ln -s $src $dest
    }
    load-paths $f $source $destination
}

def "main mount" [source, destination, owner, group, mode] {
    let f = { |src, dest|
        if not ($dest | path exists) {
            create-dir $dest $owner $group $mode
        }
        mount -o x-gvfs-hide --bind $src $dest
    }
    load-paths $f $source $destination
}

def main [] {

}