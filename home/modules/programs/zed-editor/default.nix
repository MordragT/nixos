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
        "scheme"
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
        ui_font_size = 19;
        ui_font_family = "Geist";
        buffer_font_size = 15;
        buffer_font_family = "Geist Mono";
        tab_bar.show = false;
        show_wrap_guides = true;
        indent_guides.enabled = false;
        inlay_hints = {
          enabled = true;
          show_parameter_hints = false;
        };
        toolbar = {
          breadcrumbs = true;
          quick_actions = true;
          selections_menu = true;
        };
        project_panel = {
          dock = "right";
          entry_spacing = "standard";
          indent_guides.show = "never";
        };
        outline_panel.dock = "right";
        collaboration_panel.dock = "right";
        git_panel.dock = "right";
        notification_panel.dock = "left";
        chat_panel.dock = "left";
        assistant = {
          enabled = true;
          dock = "left";
          version = "2";
          default_model = {
            provider = "zed.dev"; # google
            model = "claude-3-7-sonnet-latest"; # gemini-1.5-flash
          };
        };
        terminal = {
          dock = "left";
          default_width = 480;
          toolbar.breadcrumbs = false;
        };
        language_models.ollama = {
          api_url = "http://localhost:11434";
          available_models = [];
        };
        language_models.lamma-cpp.api_url = "http://localhost:8030";
        file_scan_exclusions = [
          "**/.git"
          "**/.svn"
          "**/.hg"
          "**/.jj"
          "**/CVS"
          "**/.DS_Store"
          "**/Thumbs.db"
          "**/.classpath"
          "**/.settings"
          "**/.direnv"
        ];
        features = {
          edit_prediction_provider = "zed";

        };
        edit_predictions.mode = "subtle";
        # base_keymap = "SublimeText";
        languages = {
          Nix = {
            language-servers = ["!nixd" "nil"];
            formatter.external = {
              command = "alejandra";
              arguments = ["--quiet" "--"];
            };
          };
        };
      };
    };
  };
}
