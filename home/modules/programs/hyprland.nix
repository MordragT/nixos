{
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.programs.hyprland;
in {
  options.mordrag.programs.hyprland = {
    enable = lib.mkEnableOption "Hyprland";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      xwayland.enable = true;
      # plugins = with plugins; [ hyprbars borderspp ];

      settings = let
        mod = "SUPER";
      in {
        # exec-once = [
        #   "ags -b hypr"
        #   "hyprctl setcursor Qogir 24"
        #   "transmission-gtk"
        # ];

        monitor = [
          "DP-3, 2560x1440, 0x0, 1"
          "DP-1, 1920x1080, 2560x-256, 1, transform, 3"
          # ",preferred,auto,1"
        ];

        general = {
          layout = "dwindle";
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          #   resize_on_border = true;
        };

        input = {
          kb_layout = "us";
          # kb_model = "pc104";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = "no";
            #   disable_while_typing = true;
            #   drag_lock = true;
          };
          sensitivity = 0; # means no modification
          # float_switch_override_focus = 2;
        };

        # binds = {
        #   allow_workspace_cycles = true;
        # };

        bind = [
          #     "ALT, Q, killactive"
          "${mod}, C, killactive"
          # "${mod}, Q, exit"
          "CTRL ALT, Delete, exit"
          "ALT, Tab, focuscurrentorlast"
          "${mod}, V, togglefloating"
          #     "SUPER, F, togglefloating"
          #     "SUPER, G, fullscreen"
          #     "SUPER, O, fakefullscreen"
          "${mod}, P, pseudo"
          #     "SUPER, P, togglesplit"
          "${mod}, J, togglesplit"

          # exec
          "${mod}, T, exec, kgx"
          "${mod}, E, exec, nautilus"

          # movefocus
          "${mod}, left, movefocus, l"
          "${mod}, right, movefocus, r"
          "${mod}, up, movefocus, u"
          "${mod}, down, movefocus, d"

          # switch workspace
          "${mod}, 1, workspace, 1"
          "${mod}, 2, workspace, 2"
          "${mod}, 3, workspace, 3"
          "${mod}, 4, workspace, 4"
          "${mod}, 5, workspace, 5"
          "${mod}, 6, workspace, 6"
          "${mod}, 7, workspace, 7"
          "${mod}, 8, workspace, 8"
          "${mod}, 9, workspace, 9"
          "${mod}, 0, workspace, 10"
          "${mod}, S, togglespecialworkspace, magic"
          "${mod}, Comma, workspace, e-1"
          "${mod}, Period, workspace, e-1"

          # move window
          "${mod} SHIFT, 1, movetoworkspace, 1"
          "${mod} SHIFT, 2, movetoworkspace, 2"
          "${mod} SHIFT, 3, movetoworkspace, 3"
          "${mod} SHIFT, 4, movetoworkspace, 4"
          "${mod} SHIFT, 5, movetoworkspace, 5"
          "${mod} SHIFT, 6, movetoworkspace, 6"
          "${mod} SHIFT, 7, movetoworkspace, 7"
          "${mod} SHIFT, 8, movetoworkspace, 8"
          "${mod} SHIFT, 9, movetoworkspace, 9"
          "${mod} SHIFT, 0, movetoworkspace, 10"
          "${mod} SHIFT, S, movetoworkspace, special:magic"
          "${mod} SHIFT, Comma, movetoworkspace, e-1"
          "${mod} SHIFT, Period, movetoworkspace, e+1"

          # resive active
          "${mod} CTRL, left, resizeactive, -20 0"
          "${mod} CTRL, right, resizeactive, 20 0"
          "${mod} CTRL, up, resizeactive, 0 -20"
          "${mod} CTRL, down, resizeactive, 0 20"

          # move active
          "${mod} ALT, left, moveactive, -20 0"
          "${mod} ALT, right, moveactive, 20 0"
          "${mod} ALT, up, moveactive, 0 20"
          "${mod} ALT, down, moveactive, 0 -20"
        ];

        bindm = [
          # move/resize with LMB,RMB and dragging
          "${mod}, mouse:272, movewindow"
          "${mod}, mouse:273, resizewindow"
        ];

        decoration = {
          drop_shadow = "yes";
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1aee)";

          #   dim_inactive = false;

          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            #     new_optimizations = "on";
            #     noise = 0.01;
            #     contrast = 0.9;
            #     brightness = 0.8;
          };
        };

        animations = {
          enabled = "yes";
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          pseudotile = "yes";
          preserve_split = "yes";
          # no_gaps_when_only = "yes";
        };

        master = {
          new_is_master = true;
        };

        gestures = {
          # workspace_swipe = true;
          # workspace_swipe_forever = true;
          # workspace_swipe_numbered = true;
        };

        misc = {
          # layers_hog_keyboard_focus = false;
          # disable_splash_rendering = true;
          force_default_wallpaper = -1; # set to 0 to disable default
        };

        "device:epic-mouse-v1" = {
          sensitivity = -0.5;
        };

        windowrulev2 = "nomaximizerequest, class:.*";
      };
    };
  };
}
