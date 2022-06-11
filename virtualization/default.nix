{ pkgs, ... }:
{
    imports = [
        ./dim.nix
        ./mattermost.nix
        ./minecraft.nix
        ./taskcafe.nix
    ];

    virtualisation.docker.enable = true;
    virtualisation.waydroid.enable = true;
}