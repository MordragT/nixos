#!/usr/bin/env -S nix shell nixpkgs#nushell nixpkgs#rclone --command nu

use std log
use lib.nu [init root-path add-object]

const config_name = "config.toml"
const store_name = "store"

def main [] {

}

def "main init" [remote, destination] {
    init $remote $destination
}

def "main add" [path] {
    let root = root-path
    add-object $root $path
}

# def "main add" [path] {
#     let root = root-path
#     let absolute = pwd | path join $path

#     if not ($absolute | path exists) {
#         return "Fatal: Specified path does not exist"
#     }

#     let relative = $absolute | path relative-to $root

#     let config_file = get-config-file
#     if not ($config_file | path exists) {
#         return "Fatal: Data control is not initialized"
#     }

#     let config = open $config_file
#         | update filters { |config|
#             $config.filters | append $relative
#         }

#     $config | to toml | save -f $config_file
# }

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
