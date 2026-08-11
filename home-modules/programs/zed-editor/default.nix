{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  cfg = config.mordrag.programs.zed-editor;
in
{
  options.mordrag.programs.zed-editor = {
    enable = lib.mkEnableOption "Zed, the high performance, multiplayer code editor from the creators of Atom and Tree-sitter";
  };

  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      package = pkgs.zed-editor;

      extraPackages = with pkgs; [
        alejandra # nix formater
        copilot-language-server
        harper # grammar checker
        nil # nix language server
        nixd # TODO needed because of https://github.com/zed-industries/zed/issues/23368
        nixfmt
        prettier
        inputs.fenix.packages.${system}.rust-analyzer
        tinymist # lsp for typst
      ];

      extensions = [
        "ansible"
        "crates-lsp"
        "elixir"
        "elm"
        "emmet" # web stuff
        "harper"
        "html"
        "java"
        "just"
        "kdl"
        "kotlin"
        "leptos"
        "neocmake"
        "nix"
        "nu"
        "ruby"
        "scheme"
        "tera"
        "toml"
        "typst"
        "vue"
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
              { prompt = "Generate Documentation"; }
            ];
          };
        }
      ];
      userSettings = {
        agent = {
          enabled = true;
          dock = "left";

          default_model = {
            # zed.dev, mistral, google, copilot_chat
            provider = "google";
            # claude-sonnet-4, codestral-latest, gemini-2.5-flash, claude-sonnet-4
            # model = "claude-sonnet-4";
            model = "gemini-3.5-flash";
          };

          inline_assistant_model = {
            provider = "google";
            model = "gemini-3.5-flash";
          };

          commit_message_model = {
            provider = "google";
            model = "gemini-3.5-flash";
          };

          thread_summary_model = {
            provider = "google";
            model = "gemini-3.5-flash";
          };

          default_profile = "ask";
          profiles.ask = {
            name = "Ask";
            enable_all_context_servers = true;

            tools = {
              copy_path = false;
              create_directory = false;
              delete_path = false;
              diagnostics = true;
              edit_file = false;
              fetch = true;
              list_directory = true;
              move_path = false;
              now = true;
              find_path = true;
              read_file = true;
              grep = true;
              terminal = true;
              thinking = true;
              search_web = true;
            };
          };
        };
        agent_servers = {
          gemini = {
            type = "registry";
          };
        };
        buffer_font_family = "Geist Mono";
        buffer_font_size = 15;
        collaboration_panel.dock = "right";
        edit_predictions = {
          mode = "subtle";
          provider = "copilot";
        };
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
        git_panel.dock = "right";
        indent_guides.enabled = false;
        inlay_hints = {
          enabled = true;
          show_parameter_hints = false;
        };
        language_models = {
          openai_compatible = {
            groq = {
              api_url = "https://api.groq.com/openai/v1";
              available_models = [
                {
                  name = "openai/gpt-oss-120b";
                  display_name = "OpenAI GPT OSS 120B";
                  max_tokens = 131072;
                  capabilities = {
                    tools = true;
                    images = false;
                    parallel_tool_calls = false;
                    prompt_cache_key = false;
                  };
                }
              ];
            };
          };
          ollama = {
            api_url = "http://localhost:11434";
            available_models = [ ];
          };
        };
        languages = {
          Kola = {
            semantic_tokens = "full";
            language_servers = [ "kola-ls" ];
          };
          Nix = {
            language_servers = [
              "!nixd"
              "nil"
            ];
            formatter.external = {
              command = "nixfmt";
              arguments = [
                "--quiet"
                "--"
              ];
            };
          };
        };
        # notification_panel.dock = "left";
        outline_panel.dock = "right";
        preferred_line_length = 120;
        project_panel = {
          dock = "right";
          entry_spacing = "standard";
          indent_guides.show = "never";
        };
        show_wrap_guides = true;
        soft_wrap = "prefer_line";
        tab_bar.show = false;
        terminal = {
          dock = "left";
          default_width = 480;
          toolbar.breadcrumbs = false;
        };
        theme = "Zedokai Darker Classic";
        toolbar = {
          breadcrumbs = true;
          quick_actions = true;
          selections_menu = true;
        };
        ui_font_family = "Geist";
        ui_font_size = 19;
      };
    };
  };
}
