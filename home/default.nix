{ pkgs }:
(import ./art.nix { inherit pkgs; }) ++
(import ./audio.nix { inherit pkgs; }) ++
(import ./development.nix { inherit pkgs; }) ++
(import ./documents.nix { inherit pkgs; }) ++
(import ./gaming.nix { inherit pkgs; }) ++
(import ./gnome.nix { inherit pkgs; }) ++
(import ./security.nix { inherit pkgs; }) ++
(import ./social.nix { inherit pkgs; }) ++
(import ./tools.nix { inherit pkgs; }) ++
(import ./video.nix { inherit pkgs; })
