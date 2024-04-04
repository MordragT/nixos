#!/usr/bin/env -S nix shell nixpkgs#nushell nixpkgs#just --command 'just --justfile'

set shell := ["nu", "-c"]

update: update-firefox update-vscode
    nix flake update

update-firefox:
    use pkgs/firefox-addons; firefox-addons update

update-vscode:
    use pkgs/vscode-extensions; vscode-extensions update

create: create-firefox create-vscode

create-firefox:
    use pkgs/firefox-addons; firefox-addons create

create-vscode:
    use pkgs/vscode-extensions; vscode-extensions create
