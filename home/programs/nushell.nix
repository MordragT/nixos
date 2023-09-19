{pkgs, ...}: {
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  # programs.direnv.enableNushellIntegration = false;

  # programs.starship.enable = true;
  # programs.starship.enableNushellIntegration = true;

  programs.nushell = {
    enable = true;
    configFile.text = ''
      # def , [...pkgs: string] {
      #   let $pkgs = ($pkgs
      #     | each { |pkg| "nixpkgs#" + $pkg }
      #     | str join ' ')
      #   let cmd = $"nix shell ($pkgs)"
      #   bash -c $cmd
      # }

      alias comojit = comoji commit
      alias r = direnv reload
      # alias code = codium

      # $env.config.hooks.pre_prompt = ($env.config?.hooks?.pre_prompt? | default [] | append {
      #   code: "
      #     let direnv = (${pkgs.direnv}/bin/direnv export json | from json)
      #     let direnv = if ($direnv | length) == 1 { $direnv } else { {} }
      #     $direnv | load-env
      #     "
      # })
    '';
    envFile.text = "";
  };
}
