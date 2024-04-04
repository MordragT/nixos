#!/usr/bin/env -S nix shell nixpkgs#nushell nixpkgs#just --command 'just --justfile'

set shell := ["nu", "-c"]

update:
    nix flake update
    use pkgs/firefox-addons; firefox-addons update
    use pkgs/vscode-extensions; vscode-extensions update

create:
    use pkgs/firefox-addons; firefox-addons create
    use pkgs/vscode-extensions; vscode-extensions create