#!/usr/bin/env -S nix shell nixpkgs#nushell nixpkgs#just --command 'just --justfile'

set shell := ["nu", "-c"]

update: update-firefox update-vscode
    nix flake update

update-firefox:
    use pkgs/by-scope/firefox-addons; firefox-addons update

update-vscode:
    use pkgs/by-scope/vscode-extensions; vscode-extensions update

create: create-firefox create-vscode

create-firefox:
    use pkgs/by-scope/firefox-addons; firefox-addons create

create-vscode:
    use pkgs/by-scope/vscode-extensions; vscode-extensions create

iso system:
    nixos-generate --flake .#tom-{{ system }} --format iso

install-iso:
    nix build .#nixosConfigurations.installer.config.system.build.isoImage

disko-image system:
    nix build .#nixosConfigurations.tom-{{ system }}.config.system.build.diskoImages;