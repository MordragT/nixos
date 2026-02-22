#!/usr/bin/env -S nix shell nixpkgs#nushell --command nu

def fetch-addons [slugs: list<string>] {
    let addons = $slugs | each { |slug| fetch-addon $slug }
    return $addons
}

def fetch-addon [slug] {
    let url = $'https://addons.mozilla.org/api/v5/addons/addon/($slug)/?app=firefox&lang=en-US'
    let response = http get $url


    let slug = if (($slug | split chars | first) in ['0' '1' '2' '3' '4' '5' '6' '7' '8' '9']) {
        $'addon-($slug)'
    } else {
        $slug
    }

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
        7tv-extension
        bib-kit
        bibitnow
        bitwarden-password-manager
        brave-search
        csgofloat
        ghostery
        private-internet-access-ext
        proton-vpn-firefox-extension
        rust-search-extension
        sidebery
        skinport-plus
        sponsorblock
        ublock-origin
        youtube-shorts-block
    ]
    let addons = fetch-addons $slugs
    $addons | sort | to json | save --force $file
}
