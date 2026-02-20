{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.programs.nvim;
in
{
  options.mordrag.programs.nvim = {
    enable = lib.mkEnableOption "Neovim";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
      ];
    };
  };
}
