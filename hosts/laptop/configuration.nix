{ pkgs, ... }:
{
  mordrag = {
    boot.enable = true;
    desktop.cosmic = {
      enable = true;
      greeter = true;
    };
    disks = {
      enable = true;
      zram = true;
      swapSize = "32G";
      swapWritebackSize = "8G";
      mainPool = {
        devices.main = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_1TB_S6Z1NJ0W535010R";
        luks = true;
      };
    };
    hardware = {
      intel-i7-13700h = true;
      nitrokey = true;
      tuxedo = true;
    };
    networking = {
      enable = true;
      primary = {
        name = "wlan";
        mac = "c4:3d:1a:0c:ef:4f";
      };
    };
    platform.enable = true;
    programs = {
      git.enable = true;
      gnome-disks.enable = true;
      nautilus.enable = true;
    };
    services = {
      tailscale.enable = true;
      llama = {
        enable = true;
        port = 9090;
        device = "none";
      };
    };
    state = {
      enable = true;
    };
    users = {
      enable = true;
      main = {
        name = "tom";
        state.enable = true;
        packages = with pkgs; [
          _1password-gui
          # broken beekeeper-studio
          bruno
          drawio
          gather
          gh
          onlyoffice-desktopeditors # office suite
          opcua-commander
          slack
          teams-for-linux
        ];
      };
    };
  };

  virtualisation = {
    virtualbox.host.enable = true;
    # vmware.host.enable = true;
  };
}
