#!/usr/bin/env -S nix shell nixpkgs#nushell --command nu

def main [...pkgs: string] {
    comma $pkgs
}

export def , [...pkgs: string] {
    comma $pkgs
}

def comma [pkgs: list<string>] {
    let $pkgs = $pkgs
        | each { |pkg| "nixpkgs#" + $pkg }
    nix shell ...$pkgs
}

