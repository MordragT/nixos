#!/usr/bin/env -S nix shell nixpkgs#nushell nixpkgs#just --command 'just --justfile'

set shell := ["nu", "-c"]

update:
    use pkgs/by-scope/firefox-addons; firefox-addons
    use pkgs/by-scope/vscode-extensions; vscode-extensions
    use pkgs/by-scope/intel-dpcpp; intel-dpcpp
    use pkgs/by-name/intel-mkl; intel-mkl
    use pkgs/by-name/intel-mpi; intel-mpi
    use pkgs/by-name/intel-tbb; intel-tbb
    nix flake update

iso system:
    nixos-generate --flake .#tom-{{ system }} --format iso

install-iso:
    nix build .#nixosConfigurations.installer.config.system.build.isoImage

disko-image system:
    nix build .#nixosConfigurations.tom-{{ system }}.config.system.build.diskoImages;