{pkgs, ...}: {
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  # programs.direnv.enableNushellIntegration = false;

  # programs.starship.enable = true;
  # programs.starship.enableNushellIntegration = true;

  programs.nushell = {
    enable = true;
    package = pkgs.nushellFull;
    configFile.text = ''
      use ${../../scripts/nix/comma.nu} ,
      use ${../../scripts/vpnctl.nu} [vpnctl "vpnctl fh-aachen" "vpnctl up" "vpnctl down"]
      # broken ?? use ${../../scripts/all-to.nu} main

      register "${pkgs.nushellPlugins.formats}/bin/nu_plugin_formats"

      $env.config.rm.always_trash = true

      alias comojit = comoji commit
      alias r = direnv reload
      # alias code = codium
    '';
    envFile.text = "";
  };

  # vpnctl
  home.packages = with pkgs; [
    openconnect
    wireguard-tools
  ];
}
