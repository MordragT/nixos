{ config, pkgs, lib, ... }:
{
  system.stateVersion = "22.11";

  users.users.root = {
    extraGroups = [ "root" ];
  };

  users.users.tom = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.nushell;
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  hardware.opengl.enable = true;
  hardware.steam-hardware.enable = true;
  hardware.pulseaudio.enable = false;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # league of legends
  boot.kernel.sysctl."abi.vsyscall32" = 0;
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Fira Code";
    keyMap = "de";
  };

  security.acme.defaults.email = "connect.mordrag@gmx.de";
  security.acme.acceptTerms = true;
  # security.pam.p11.enable = true;

  environment = {
    variables = {
      EDITOR = "hx";
    };
    # loginShellInit = ''
    #   hua generations switch $(hua generations current)
    # '';
  };

  # environment.interactiveShellInit = ''
  #   alias comojit='comoji commit'
  # '';

  fonts = {
    fontDir.enable = true;
    enableDefaultFonts = true;
    fonts = with pkgs; [
      fira
      fira-code
      jetbrains-mono
      roboto
      noto-fonts
      noto-fonts-emoji
    ];
    fontconfig.defaultFonts = {
      monospace = [ "Fira Code" ];
      serif = [ "Noto Serif" ];
      sansSerif = [ "Fira Sans" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}
