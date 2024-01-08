{
  config,
  lib,
  utils,
  ...
}: let
  cfg = config.services.xserver.desktopManager.cosmic;
  pkgs =
    import (builtins.fetchTarball {
      name = "nixos-cosmic-branch";
      url = "https://github.com/nbdd0121/nixpkgs/archive/979a382ebefb0100b2fa6a016fb636e82e28f1c8.tar.gz";
      sha256 = "1l1scq4nx2g1f593fvx2j2gki0974ibn8fmvcfidhhj32vc5iyic";
    }) {
      system = "x86_64-linux";
    };
in
  with lib; {
    options = {
      environment.cosmic.excludePackages = mkOption {
        default = [];
        example = literalExpression "[ pkgs.cosmic-screenshot ]";
        type = types.listOf types.package;
        description = mdDoc "Which packages gnome should exclude from the default environment";
      };

      services.xserver.desktopManager.cosmic = {
        enable = mkEnableOption "COSCMIC desktop environment";
      };
    };

    config = mkIf cfg.enable {
      environment.systemPackages = let
        mandatoryPackages = with pkgs; [
          # cosmic-applibrary
          cosmic-applets
          # cosmic-bg
          cosmic-comp
          cosmic-icons
          cosmic-launcher
          # cosmic-notifications
          cosmic-osd
          cosmic-panel
          # cosmic-screenshot
          cosmic-settings
          # cosmic-settings-daemon
          cosmic-workspaces-epoch
          xdg-desktop-portal-cosmic

          # Not in unstable
          cosmic-applibrary
          cosmic-bg
          cosmic-notifications
          cosmic-screenshot
          cosmic-settings-daemon
        ];
        optionalPackages = with pkgs; [
          # TODO check which are optional
          cosmic-edit
          cosmic-term
        ];
      in
        mandatoryPackages
        ++ utils.removePackagesByName optionalPackages config.environment.cosmic.excludePackages;

      xdg.portal.extraPortals = with pkgs; [
        xdg-desktop-portal-cosmic
      ];

      xdg.portal.configPackages = [
        (pkgs.writeTextDir "share/xdg-desktop-portal/cosmic-portals.conf" ''
          [preferred]
          default=gtk
          org.freedesktop.impl.portal.Screencast=cosmic
          org.freedesktop.impl.portal.Screenshot=cosmic
        '')
      ];

      # session files for display manager and systemd
      # TODO not in unstable
      services.xserver.displayManager.sessionPackages = with pkgs; [cosmic-session];
      systemd.packages = with pkgs; [cosmic-session];
    };
  }
