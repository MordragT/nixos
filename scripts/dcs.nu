#!/usr/bin/env -S nix shell nixpkgs#nushellFull nixpkgs#rclone --command nu

use std log

const config_name = "config.toml"

def main [] {

}

def "main init" [remote, destination] {
    if not (is-git) {
        return "Fatal: Not inside a git repository."
    }
    let config_dir = get-config-dir

    if ($config_dir | path exists) {
        return "Fatal: Data control already initialized."
    }

    mkdir $config_dir
    let config = {
        remote: $remote
        destination: $destination
        filters: []
    }

    $config | to toml | save $"($config_dir)/($config_name)"
}

def "main add" [path] {
    let root = get-root
    let absolute = pwd | path join $path

    if not ($absolute | path exists) {
        return "Fatal: Specified path does not exist"
    }

    let relative = $absolute | path relative-to $root

    let config_file = get-config-file
    if not ($config_file | path exists) {
        return "Fatal: Data control is not initialized"
    }

    let config = open $config_file
        | update filters { |config|
            $config.filters | append $relative
        }

    $config | to toml | save -f $config_file
}

def "main remove" [path] {
    let root = get-root
    let absolute = pwd | path join $path
    let relative = $absolute | path relative-to $root

    let config_file = get-config-file
    if not ($config_file | path exists) {
        return "Fatal: Data control is not initialized"
    }

    let config = open $config_file
        | update filters { |config|
            $config.filters | where { |entry| $entry != $relative }
        }

    $config | to toml | save -f $config_file
}

def "main sync" [] {
    let config_file = get-config-file
    if not ($config_file | path exists) {
        return "Fatal: Data control is not initialized"
    }

    let config = open $config_file

    let tmp_path = $"(get-config-dir)/filters"
    let filters = $config.filters
        | str join "\n"
        | save $tmp_path
    let root = get-root

    rclone $"--include-from=($tmp_path)" sync $root $"($config.remote):($config.destination)"

    rm $tmp_path
}

def "main status" [] {
    let config_file = get-config-file
    if not ($config_file | path exists) {
        return "Fatal: Data control is not initialized"
    }

    let config = open $config_file

    # TODO better printing
    echo ($config | reject filters)
    echo $config.filters
    # echo ($config | table -e)
}

def get-root [] {
    let root = git rev-parse --show-toplevel
    return $root
}

def get-config-dir [] {
    let root = get-root
    let config_dir = $root | path join ".dcs"
    return $config_dir
}

def get-config-file [] {
    let config_dir = get-config-dir
    let config_file = $"($config_dir)/($config_name)"
    return $config_file
}

def is-git [] {
    let output = do { git rev-parse --is-inside-work-tree } | complete
    return ($output.exit_code == 0)
}