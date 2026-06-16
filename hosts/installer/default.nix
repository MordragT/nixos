{
  mordrag.hosts.installer = {
    system = "x86_64-linux";
    stateVersion = "26.05";
    modules = [
      (
        {
          pkgs,
          lib,
          modulesPath,
          ...
        }:
        {
          imports = [
            "${toString modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
          ];

          mordrag.platform.nix.enable = true;

          users.users.nixos = {
            initialPassword = "nixos";
            initialHashedPassword = lib.mkForce null;
          };
          services.getty.autologinUser = "nixos";

          environment.systemPackages = with pkgs; [
            disko
            git
            helix
          ];
        }
      )
    ];
  };
}
