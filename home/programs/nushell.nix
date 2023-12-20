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
      # def , [...pkgs: string] {
      #   let $pkgs = ($pkgs
      #     | each { |pkg| "nixpkgs#" + $pkg }
      #     | str join ' ')
      #   let cmd = $"nix shell ($pkgs)"
      #   bash -c $cmd
      # }

      $env.config.rm.always_trash = true

      alias comojit = comoji commit
      alias r = direnv reload
      # alias code = codium
    '';
    envFile.text = "";
  };
}
