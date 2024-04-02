#!/usr/bin/env -S nix shell nixpkgs#unzip nixpkgs#nushell --command nu

def main [] {}

def "main by-tuple" [publisher, name] {
    get-vsixpkg $publisher $name
}

def "main list" [] {
    nix-vscode list
}

export def "nix-vscode by-tuple" [publisher, name] {
    get-vsixpkg $publisher $name
}

export def "nix-vscode list" [] {
    code --list-extensions | lines | par-each { |extension|
        let combined = ($extension | split row '.')
        let publisher = $combined.0
        let name = $combined.1
        get-vsixpkg $publisher $name
    }
}

def get-vsixpkg [publisher, name] {
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