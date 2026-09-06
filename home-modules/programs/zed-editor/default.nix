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

          auto_compact = {
            enabled = true;
            threshold = "85%";
          };

          default_model = {
            # zed.dev, mistral, google, copilot_chat
            provider = "copilot_chat";
            # claude-sonnet-4, codestral-latest, gemini-2.5-flash, claude-sonnet-4
            model = "auto";
          };

          inline_assistant_model = {
            provider = "copilot_chat";
            model = "auto";
          };

          commit_message_model = {
            provider = "copilot_chat";
            model = "auto";
          };

          thread_summary_model = {
            provider = "copilot_chat";
            model = "auto";
          };

          favorite_models = [
            {
              provider = "copilot_chat";
              model = "auto";
            }
            {
              provider = "openrouter";
              model = "openrouter/free";
            }
          ];

          default_profile = "ask";

          # Default profiles, removed ones commented out
          profiles = {
            ask = {
              name = "Ask";
              enable_all_context_servers = false;

              tools = {
                create_thread = true;
                diagnostics = true;
                fetch = true;
                # list_agents_and_models = true;
                list_directory = true;
                find_path = true;
                find_references = true;
                # get_code_actions = true; # more of a write feature ?
                go_to_definition = true;
                read_file = true;
                grep = true;
                # skill = true; # do not use skills
                spawn_agent = true;
                search_web = true;
              };
            };

            write = {
              name = "Write";
              enable_all_context_servers = false;

              tools = {
                copy_path = true;
                create_directory = true;
                create_thread = true;
                delete_path = true;
                diagnostics = true;
                apply_code_action = true;
                edit_file = true;
                write_file = true;
                fetch = true;
                find_path = true;
                find_references = true;
                get_code_actions = true;
                go_to_definition = true;
                # list_agents_and_models= true; # not needed
                list_directory = true;
                move_path = true;
                rename_symbol = true;
                read_file = true;
                grep = true;
                # skill= true; # do not use skills
                spawn_agent = true;
                terminal = true;
                search_web = true;
              };
            };
          };
        };
        agent_servers = {
          antigravity = {
            type = "registry";
          };

          github_copilot = {
            type = "registry";
          };

          mistral_vibe = {
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
        format_on_save = "on";
        formatter = "auto";
        git_panel.dock = "right";
        indent_guides.enabled = false;
        inlay_hints = {
          enabled = true;
          show_parameter_hints = false;
        };
        language_models = {
          "llama.cpp" = {
            api_url = "http://localhost:8080";
            auto_discover = true;
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
