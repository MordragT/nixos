#!/usr/bin/env -S nix shell nixpkgs#nushell --command nu

use lib.nu

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