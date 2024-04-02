#!/usr/bin/env -S nix shell nixpkgs#nushell --command nu

module lib {
    export def update [file] {
        let addons = open $file
        let addons = $addons | each { |addon| get-addon $addon.slug }
        $addons | save --force $file
    }

    export def create [slugs: list<string>, dest] {
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
}

use lib

# change this when the following gets resolved
# https://github.com/nushell/nushell/issues/12195
const file = "/home/tom/Desktop/Mordrag/nixos/pkgs/firefox-addons/addons.json"
const slugs = [
    bib-kit
    bibitnow
    brave-search
    private-internet-access-ext
]

export def update [] {
    lib update $file
}

export def create [] {
    lib create $slugs $file
}