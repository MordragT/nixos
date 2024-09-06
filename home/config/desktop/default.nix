{pkgs, ...}: {
  imports = [
    ../base
  ];

  mordrag.programs.bottles.enable = true;
  mordrag.programs.firefox.enable = true;
  mordrag.programs.git.enable = true;
  mordrag.programs.helix.enable = true;
  mordrag.programs.loupe.enable = true;
  mordrag.programs.mangohud.enable = true;
  mordrag.programs.nushell.enable = true;
  mordrag.programs.obs.enable = true;
  mordrag.programs.papers.enable = true;
  mordrag.programs.thunderbird.enable = true;
  mordrag.programs.totem.enable = true;
  mordrag.programs.vscode.enable = true;
  mordrag.programs.zed-editor.enable = true;
  mordrag.programs.zen-browser.enable = true;
  mordrag.programs.zsh.enable = true;

  programs.chromium = {
    enable = true;
  };

  mordrag.collection.cli.enable = true;
  mordrag.collection.cosmic.enable = true;
  mordrag.collection.free.enable = true;
  mordrag.collection.gaming.enable = true;
  mordrag.collection.gnome.enable = true;
  mordrag.collection.nonfree.enable = true;

  home.packages = with pkgs; [
    microsoft-edge
  ];

  # mordrag.bottles.gta-v = {
  #   wine-env = pkgs.mkWineEnv {
  #     pname = "rockstar-games";
  #     registry = [
  #       {
  #         path = ''HKCU\Software\Wine\Drivers'';
  #         key = "Graphics";
  #         type = "REG_SZ";
  #         value = "wayland";
  #       }
  #       {
  #         path = ''HKCU\Software\Wine'';
  #         key = "Version";
  #         type = "REG_SZ";
  #         value = "win10";
  #       }
  #       {
  #         path = ''HKCU\Software\Wine\DLLOverrides'';
  #         key = "winedbg.exe";
  #         type = "REG_SZ";
  #         value = "disabled";
  #       }
  #     ];
  #   };

  #   directory = "/run/media/Media/Programs/Bottles/Rockstar-Games";
  #   cmd = "drive_c/Program Files/Rockstar Games/Launcher/Launcher.exe";
  # };
}
