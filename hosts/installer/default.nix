{
  mordrag.hosts.installer = {
    system = "x86_64-linux";
    stateVersion = "26.05";
    modules = [
      (
        {
          pkgs,
          modulesPath,
          ...
        }:
        {
          imports = [
            "${toString modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
          ];

          mordrag.platform.nix.enable = true;

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
