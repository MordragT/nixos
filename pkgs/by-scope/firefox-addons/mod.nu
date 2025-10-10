#!/usr/bin/env -S nix shell nixpkgs#nushell --command nu

def fetch-addons [slugs: list<string>] {
    let addons = $slugs | each { |slug| fetch-addon $slug }
    return $addons
}

def fetch-addon [slug] {
    let url = $'https://addons.mozilla.org/api/v5/addons/addon/($slug)/?app=firefox&lang=en-US'
    let response = http get $url

    let addon = {
        slug: $slug
        name: $response.name.en-US,
        version: $response.current_version.version,
        addonId: $response.guid,
        url: $response.current_version.file.url
        sha256: $response.current_version.file.hash
        homepage: ($response | get -o homepage.url.en-US | default $response.url)
        description: $response.summary.en-US
        license: $response.current_version.license.slug
    }
    return $addon
}

export def main [] {
    const file = path self ./default.lock
    const slugs = [
        bib-kit
        bibitnow
        brave-search
        csgofloat
        private-internet-access-ext
        skinport-plus
    ]
    let addons = fetch-addons $slugs
    $addons | sort | to json | save --force $file
}
