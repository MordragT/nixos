{ ... }:
{
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  #programs.starship.enable = true;
  #programs.starship.enableNushellIntegration = true;

  programs.nushell = {
    enable = true;
    configFile.text = ''      
      def , [...pkgs: string] {
        let $pkgs = ($pkgs
          | each { |pkg| "nixpkgs#" + $pkg }
          | str collect ' ')
        let cmd = $"nix shell ($pkgs)"
        bash -c $cmd
      }
      
      alias comojit = comoji commit
      
      let-env config = {
        table_mode: rounded
        hooks: {
          pre_prompt: [{
            code: "
              let direnv = (direnv export json | from json)
              let direnv = if ($direnv | length) == 1 { $direnv } else { {} }
              $direnv | load-env
            "
          }]
        }
      }
    '';
    envFile.text = "";
  };
}
