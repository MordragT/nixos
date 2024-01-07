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
      use ${../../scripts/comma.nu} ,
      # broken ?? use ${../../scripts/all-to.nu} main

      $env.config.rm.always_trash = true

      alias comojit = comoji commit
      alias r = direnv reload
      # alias code = codium
    '';
    envFile.text = "";
  };
}
