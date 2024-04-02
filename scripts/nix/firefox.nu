#!/usr/bin/env -S nix shell nixpkgs#nushell --command nu

use utils.nu "to nix"

def main [] {}

def "main update" [file] {
    nix-firefox update $file
}

def "main create" [...slugs, --dest="addons.json"] {
    nix-firefox create $slugs $dest
}

export def "nix-firefox update" [file] {
    let addons = open $file
    let addons = $addons | each { |addon| get-addon $addon.slug }
    $addons | save --force $file
}

export def "nix-firefox create" [slugs: list<string>, dest] {
    let addons = get-addons $slugs
    ($addons | to json) | save $dest
}

def get-addons [slugs: list<string>] {
    let addons = $slugs | each { |slug| get-addon $slug }
    return $addons
}

def get-addon [slug] {
    let url = $'https://addons.mozilla.org/api/v5/addons/addon/($slug)/?app=firefox&lang=en-US'
    let response = http get $url
    let addon = {
        slug: $slug
        name: $response.name.en-US,
        version: $response.current_version.version,
        addonId: $response.guid,
        url: $response.current_version.file.url
        sha256: $response.current_version.file.hash
        homepage: $response.homepage.url.en-US
        description: $response.summary.en-US
        license: $response.current_version.license.slug  
    }
    return $addon
}