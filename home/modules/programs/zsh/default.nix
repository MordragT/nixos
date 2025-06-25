{
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.programs.zsh;
in {
  options.mordrag.programs.zsh = {
    enable = lib.mkEnableOption "Zsh";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;

      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = ["git" "colorize" "z"];
      };

      shellAliases = {
        "..." = "../..";
      };

      initContent = ''
        export PATH=$PATH:$HOME/.bin:$HOME/.local/bin

        # Rust
        export PATH=$PATH:$HOME/.cargo/bin

        # Editor
        export EDITOR="hx"
      '';
    };
  };
}
