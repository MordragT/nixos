{ pkgs, ... }:
{
  vaultix = {
    settings.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICS5VqBeNWhTolWxS01+dpg3zcw5OMRaSF5Ylwk1fn1v root@tom-desktop";
  };

  mordrag = {
    boot = {
      enable = true;
      secureBoot = true;
      thp = true;
      v4l2loopback = true;
      tmpSize = "50%";
    };
    desktop = {
      cosmic = {
        enable = true;
        greeter = true;
      };
      gnome.enable = true;
      niri.enable = true;
    };
    hardware = {
      amd-r5-2600 = true;
      intel-arc-a750 = true;
    };
    networking = {
      enable = true;
      lanMac = "30:9c:23:8a:54:c6";
      wlanMac = "14:f6:d8:b3:fd:f3";
    };
    platform.enable = true;
    users = {
      enable = true;
      main = {
        name = "tom";
        state.enable = true;
        xdg.enable = true;
        packages = with pkgs; [
          beekeeper-studio # sql client
          blender # 3d modeling
          blockbench # 3d modeling for games
          discord
          gimp3 # image editor
          # glaxnimate # 2d/3d vector animation software
          drawio # diagram editor
          inkscape # vector graphics editor
          krita # digital painting
          material-maker # procedural texture generator
          onlyoffice-desktopeditors # office suite
          ookla-speedtest
          pixelorama # 2d sprite editor
          prismlauncher # minecraft launcher
          proton-vpn # VPN client
          qbittorrent # download torrents
          teamfight-tactics
          teams-for-linux # microsoft teams
        ];
      };
    };
  };

  programs.chromium.enable = true;

  # files not yet supported by mordrag.users.main.state
  systemd.tmpfiles.rules = [
    "d /home/tom/.config - tom users - -"
    "L /home/tom/.config/monitors.xml - tom users - /state/users/tom/config/monitors.xml"
    "L /home/tom/.config/mimeapps.list - tom users - /state/users/tom/config/mimeapps.list"
    # bind mounting trash does not seem to work
    # "L /home/tom/.local/share/Trash - - - - /nix/state/users/tom/trash"
  ];
}
