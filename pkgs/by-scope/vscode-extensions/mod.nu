#!/usr/bin/env -S nix shell nixpkgs#unzip nixpkgs#nushell --command nu


def fetch-vsixpkgs [slugs: list<string>] {
    let extensions = $slugs | each { |slug| fetch-vsixpkg $slug }
    return $extensions
}

def fetch-vsixpkg [slug] {
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


export def main [] {
    const file = path self ./default.lock
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
        tabbyml.vscode-tabby
        tweag.vscode-nickel
        wcrichton.flowistry
    ]
    let extensions = fetch-vsixpkgs $slugs
    $extensions | to json | save --force $file
}