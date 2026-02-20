{
  config,
  lib,
  # pkgs,
  ...
}:
let
  cfg = config.mordrag.services.espanso;
in
{
  options.mordrag.services.espanso = {
    enable = lib.mkEnableOption "Espanso";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."espanso/config/default.yml".text = builtins.toJSON {
      toggle_key = "RIGHT_SHIFT"; # double clicking enables and disables
      search_shortcut = "CMD+SPACE"; # off
      show_notifications = true;
      keyboard_layout.layout = "us";
      preserve_clipboard = true;
    };

    xdg.configFile."espanso/match/default.yml".text = builtins.toJSON {
      matches = [
        {
          trigger = ":ae";
          replace = "ä";
          propagate_case = true;
        }
        {
          trigger = ":oe";
          replace = "ö";
          propagate_case = true;
        }
        {
          trigger = ":ue";
          replace = "ü";
          propagate_case = true;
        }
        {
          trigger = ":ss";
          replace = "ß";
          propagate_case = true;
        }

        {
          trigger = ":thumbsup";
          replace = "👍";
        }
        {
          trigger = ":thumbsdown";
          replace = "👎";
        }
        {
          trigger = ":ok";
          replace = "👌";
        }
        {
          trigger = ":heart";
          replace = "❤️";
        }
        {
          trigger = ":star";
          replace = "⭐";
        }
        {
          trigger = ":fire";
          replace = "🔥";
        }
        {
          trigger = ":happy";
          replace = "🙂";
        }
        {
          trigger = ":sad";
          replace = "🙁";
        }

        {
          trigger = ":now";
          replace = "{{now}}";
          vars = [
            {
              name = "now";
              type = "date";
              params.format = "%H:%M";
            }
          ];
        }
        {
          trigger = ":today";
          replace = "{{today}}";
          vars = [
            {
              name = "today";
              type = "date";
              params.format = "%d/%m/%Y";
            }
          ];
        }
      ];
    };

    # services.espanso = {
    #   enable = true;
    #   x11Support = false;

    #   configs.default = {
    #     toggle_key = "RIGHT_SHIFT"; # double clicking enables and disables
    #     search_shortcut = "CMD+SPACE"; # off
    #     show_notifications = false;
    #     keyboard_layout.layout = "us";
    #     preserve_clipboard = true;
    #   };

    #   matches.default.matches = [
    #     {
    #       trigger = ":now";
    #       replace = "{{now}}";
    #       vars = [
    #         {
    #           name = "now";
    #           type = "date";
    #           params.format = "%H:%M";
    #         }
    #       ];
    #     }
    #     {
    #       trigger = ":today";
    #       replace = "{{today}}";
    #       vars = [
    #         {
    #           name = "today";
    #           type = "date";
    #           params.format = "%d/%m/%Y";
    #         }
    #       ];
    #     }
    #   ];
    # };
  };
}
