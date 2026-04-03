{ pkgs, ... }:
{
  mordrag = {
    core.enable = true;

    programs = {
      firefox.enable = true;
      mangohud.enable = true;
      nushell.enable = true;
      vscode.enable = true;
      zed-editor.enable = true;
      zen-browser.enable = true;
    };

    gnome.enable = true;
  };

  home.packages = with pkgs; [
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
}
