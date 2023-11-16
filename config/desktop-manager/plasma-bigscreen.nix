{
  lib,
  pkgs,
  ...
}: {
  services.xserver = {
    enable = true;
    displayManager = {
      defaultSession = "plasma-bigscreen-wayland"; # steam
      autoLogin = {
        enable = true;
        user = "tom";
      };
      sddm.enable = true;
      sddm.wayland.enable = true;
      sddm.autoLogin.relogin = true;
    };
    desktopManager.plasma5 = {
      # mobile.enable = true;
      kdeglobals = {
        KDE = {
          LookAndFeelPackage = lib.mkDefault "org.kde.plasma.mycroft.bigscreen";
        };
      };
      kwinrc = {
        Windows = {
          BorderlessMaximizedWindows = true;
        };
      };
      # kwinrc = {
      #   "Wayland" = {
      #     "InputMethod[$e]" = "/run/current-system/sw/share/applications/com.github.maliit.keyboard.desktop";
      #     "VirtualKeyboardEnabled" = "true";
      #   };
      #   "org.kde.kdecoration2" = {
      #     # No decorations (title bar)
      #     NoPlugin = lib.mkDefault "true";
      #   };
      # };
      bigscreen.enable = true;
      useQtScaling = true;
    };
  };

  environment.systemPackages = with pkgs; [
    maliit-framework
    maliit-keyboard
  ];
}
