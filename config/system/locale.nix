{pkgs, ...}: {
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # packages = with pkgs; [
    #   fira-code
    # ];
    # font = "Fira Code";
    keyMap = "us";
  };
}
