{
  config,
  lib,
  master,
  utils,
  ...
}: let
  pkgs = master;
  cfg = config.services.xserver.desktopManager.cosmic;
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

    # config = mkIf cfg.enable {
    #   environment.systemPackages = let
    #     mandatoryPackages = with pkgs; [
    #       # cosmic-applibrary
    #       cosmic-applets
    #       # cosmic-bg
    #       cosmic-comp
    #       cosmic-icons
    #       # cosmic-launcher
    #       # cosmic-notifications
    #       # cosmic-osd
    #       cosmic-panel
    #       # cosmic-screenshot
    #       cosmic-settings
    #       # cosmic-settings-daemon
    #       # cosmic-workspaces-epoch
    #       # xdg-desktop-portal-cosmic
    #     ];
    #     optionalPackages = with pkgs; [
    #       # TODO check which are optional
    #       cosmic-edit
    #     ];
    #   in
    #     mandatoryPackages
    #     ++ utils.removePackagesByName optionalPackages config.environment.cosmic.excludePackages;

    #   # session files for display manager and systemd
    #   services.xserver.displayManager.sessionPackages = with pkgs; [cosmic-session];
    #   systemd.packages = with pkgs; [cosmic-session];
    # };
  }
