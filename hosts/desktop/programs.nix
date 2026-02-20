{ pkgs, ... }:
{
  mordrag = {
    programs = {
      gnome-disks.enable = true;
      lsfg-vk.enable = true;
      mediatek-utils.enable = true;
      nautilus.enable = true;
      steam = {
        enable = true;
        compatPackages = with pkgs; [
          proton-ge-bin
          # luxtorpeda # broken: sadly chaotic nyx is discontinued
          opengothic
        ];
      };
      valent.enable = true;
    };
  };

  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };
}
