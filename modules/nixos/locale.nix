{
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.locale;
in {
  options.mordrag.locale = {
    enable = lib.mkEnableOption "Locale";
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = "Europe/Berlin";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      # TODO Need to specify full path until: https://github.com/NixOS/nixpkgs/pull/299456
      # font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
      # Setting font is completely broken: https://github.com/NixOS/nixpkgs/issues/202846
      # font = "${pkgs.spleen}/share/consolefonts/spleen-12x24.psfu";
      keyMap = "us";
      # earlySetup = true;
    };
  };
}
