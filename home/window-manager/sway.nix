{lib, ...}: let
  modifier = "Mod1";
in {
  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;
    config = {
      gaps = {
        outer = 0;
        inner = 10;
      };

      keybindings = lib.mkOptionDefault {
        # "${modifier}+Return" = mkExec "wezterm start --always-new-process";
        "${modifier}+Shift+Return" = "exec kgx";
        "${modifier}+q" = "kill";
        # "${modifier}+Shift+r" = "reload";
        # "${modifier}+space" = "exec pkill wofi || ${mkExec "wofi --show drun -I"}";
        # "${modifier}+z" = "floating toggle";
        "${modifier}+e" = "exec nautilus";
        # XF86AudioRaiseVolume = "exec volume 5%+";
        # XF86AudioLowerVolume = "exec volume 5%-";
        # "Prior" = XF86AudioRaiseVolume; # PageDown
        # "Next" = XF86AudioLowerVolume; # PageUp
        # "XF86AudioMute" = "exec volume toggle-mute";
        # "XF86AudioMicMute" = "exec volume -m toggle-mute";
        # "Ctrl+Alt+Delete" = "exec power-menu";
      };
    };
  };
}
