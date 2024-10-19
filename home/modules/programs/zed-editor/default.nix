{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mordrag.programs.zed-editor;
in {
  options.mordrag.programs.zed-editor = {
    enable =
      mkEnableOption
      "Zed, the high performance, multiplayer code editor from the creators of Atom and Tree-sitter";
  };

  config = mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "html"
        "java"
        "just"
        "kotlin"
        "nix"
        "nu"
        "toml"
        "typst"
        "wgsl"
        "zedokai"
        "zig"
      ];
      userSettings = {
        theme = "Zedokai Darker Classic";
        ui_font_size = 18;
        ui_font_family = "Geist";
        buffer_font_size = 14;
        buffer_font_family = "Geist Mono";
        tab_bar.show = false;
        show_wrap_guides = true;
        indent_guides.enabled = false;
        toolbar = {
          breadcrumbs = true;
          quick_actions = true;
          selections_menu = true;
        };
        assistant.enabled = true;
        assistant.version = "1";
        assistant.provider = {
          name = "ollama";
          # Recommended setting to allow for model startup
          low_speed_timeout_in_seconds = 30;
          default_model = {
            name = "gemma2:9b-instruct-q4_K_S";
            max_tokens = 8192;
            keep_alive = "10m";
          };
        };
        # base_keymap = "SublimeText";
      };
    };
  };
}
