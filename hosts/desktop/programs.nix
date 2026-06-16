{ pkgs, ... }:
{
  mordrag = {
    programs = {
      git.enable = true;
      gnome-disks.enable = true;
      lsfg-vk.enable = true;
      nautilus.enable = true;
      steam = {
        enable = true;
        compatPackages = with pkgs; [
          proton-ge-bin
          # opengothic
        ];
      };
      valent.enable = true;
      vscode.enable = true;
    };
  };

  programs = {
    ausweisapp = {
      enable = true;
      openFirewall = true;
    };
    thunderbird.enable = true;
  };

  security.wrappers.samply = {
    source = "${pkgs.samply}/bin/samply";
    owner = "root";
    group = "wheel";
    permissions = "0750";
    capabilities = "cap_perfmon=ep";
  };

}
