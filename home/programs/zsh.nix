{ ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "colorize" "z" ];
    };

    shellAliases = {
      "..." = "../..";
    };

    initExtra = ''
      export PATH=$PATH:$HOME/.bin:$HOME/.local/bin
        
      # Rust
      export PATH=$PATH:$HOME/.cargo/bin
        
      # Editor
      export EDITOR="hx"
    '';
  };
}
