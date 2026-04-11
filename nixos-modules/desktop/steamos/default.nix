{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.desktop.steamos;
in
{
  options.mordrag.desktop.steamos = {
    enable = lib.mkEnableOption "Steam OS";
  };

  config = lib.mkIf cfg.enable {
    mordrag.desktop.cosmic.enable = true;

    environment.systemPackages = with pkgs; [
      steamos-cosmic-session-select
      steamos-select-branch
      steamos-update
    ];

    mordrag.programs.steam.enable = true;
    # TODO add as argument to own steam module
    programs.steam.gamescopeSession = {
      args = [
        # "-W 1280"
        # "-H 720"
        # "-F fsr" # doesn't seem to work that well
        "--mangoapp"
        "--fullscreen" # gamescope introduces a lot of latency if not fullscreen
      ];
      steamArgs = [
        "-steamos3"
        "-tenfoot"
        "-pipewire-dmabuf"
      ];
      # somehow --mangoapp on gamescope doesn't find default config
      env.MANGOHUD_CONFIGFILE = "/home/tom/.config/MangoHud/MangoHud.conf";
    };

    services = {
      greetd = {
        enable = true;
        settings = {
          default_session = {
            user = "tom";
            command = "steam-gamescope";
          };
        };
      };
    };
  };
}
