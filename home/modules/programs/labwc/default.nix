{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.programs.labwc;
in {
  options.mordrag.programs.labwc = {
    enable = lib.mkEnableOption "labwc";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.wlr-randr];

    wayland.windowManager.labwc = {
      enable = true;

      autostart = [
        "cosmic-bg &"
        "cosmic-panel"
      ];

      rc = {
        core = {
          allowTearing = true;
        };

        theme = {
          cornerRadius = 10;
        };

        keyboard = {
          keybind = [
            {
              "@key" = "W-a";
              action = {
                "@name" = "Launcher";
                "@command" = "cosmic-launcher";
              };
            }
            {
              "@key" = "W-q";
              action = {
                "@name" = "Close";
              };
            }
          ];
        };
      };
    };
  };
}
