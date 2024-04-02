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
      const scripts = ${../../scripts}

      # cannot use files directly as that would rename them to a hash
      # and would clash with nushell module system
      use $"($scripts)/comma.nu" ,
      use $"($scripts)/vpnctl.nu"
      use $"($scripts)/all-to.nu"
      use $"($scripts)/superview.nu"

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
