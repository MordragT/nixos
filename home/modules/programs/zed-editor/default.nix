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
      userKeymaps = [
        {
          context = "Editor && mode == full";
          bindings = {
            ctrl-shift-enter = [
              "assistant::InlineAssist"
              {prompt = "Generate Documentation";}
            ];
          };
        }
      ];
      userSettings = {
        theme = "Zedokai Darker Classic";
        ui_font_size = 20;
        ui_font_family = "Geist";
        buffer_font_size = 16;
        buffer_font_family = "Geist Mono";
        tab_bar.show = false;
        show_wrap_guides = true;
        indent_guides.enabled = false;
        toolbar = {
          breadcrumbs = true;
          quick_actions = true;
          selections_menu = true;
        };
        language_models.ollama = {
          api_url = "http://localhost:11434";
          available_models = [];
        };
        language_models.lamma-cpp.api_url = "http://localhost:8030";
        assistant.enabled = true;
        assistant.version = "2";
        assistant.default_model = {
          provider = "zed.dev"; # google
          model = "claude-3-7-sonnet-latest"; # gemini-1.5-flash
        };
        # base_keymap = "SublimeText";
      };
    };
  };
}
