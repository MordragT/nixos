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
        shortcuts = [
          {
            name = "Mario Kart Wii";
            exe = "${pkgs.dolphin-emu}/bin/dolphin-emu";
            args = [
              "-b"
              "-e"
              "/run/media/Media/Games/Wii/mario-party-8.wbfs"
            ];
          }
        ];
      };
      valent.enable = true;
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
