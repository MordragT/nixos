#!/usr/bin/env -S nix shell nixpkgs#unzip nixpkgs#nushell --command nu

module lib {
    export def update [file] {
        let extensions = open $file
        let extensions = $extensions | each { |ext| get-vsixpkg $"($ext.publisher).($ext.name)" }
        $extensions | save --force $file
    }

    export def create [slugs: list<string>, dest] {
        let extensions = get-vsixpkgs $slugs
        ($extensions | to json) | save $dest
    }

    def get-vsixpkgs [slugs: list<string>] {
        let extensions = $slugs | each { |slug| get-vsixpkg $slug }
        return $extensions
    }

    def get-vsixpkg [slug] {
        let combined = ($slug | split row '.')
        let publisher = $combined.0
        let name = $combined.1

        let tmp = (mktemp -d -t vscode_exts_XXXXXXXX)
        let url = $"https://($publisher).gallery.vsassets.io/_apis/public/gallery/publisher/($publisher)/extension/($name)/latest/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage"
    
        let path = $"($tmp)/($publisher).($name).zip"
        (http get $url | save $path)
    
        let package = (unzip -qc $path "extension/package.json" | from json)
        let hash = (nix hash file --base32 $path)
        (rm --recursive $tmp)
    
        return {
            name: $name,
            publisher: $publisher,
            version: $package.version,
            sha256: $hash,
        }
    }
}

use lib

# change this when the following gets resolved
# https://github.com/nushell/nushell/issues/12195
const file = "/home/tom/Desktop/Mordrag/nixos/pkgs/vscode-extensions/extensions.json"
# can be gathered with code --list-extensions
const slugs = [
    cesium.gltf-vscode
    efoerster.texlab
    fwcd.kotlin
    jsinger67.parol-vscode
    Mordrag.one-dark-vibrant
    ms-vscode.sublime-keybindings
    PolyMeilex.wgsl
    streetsidesoftware.code-spell-checker-german
    tweag.vscode-nickel
    wcrichton.flowistry
]

export def update [] {
    lib update $file
}

export def create [] {
    lib create $slugs $file
}
