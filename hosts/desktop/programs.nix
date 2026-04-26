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
          opengothic
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
}
