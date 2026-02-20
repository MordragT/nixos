{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.mordrag.programs.zed-editor;
in
{
  options.mordrag.programs.zed-editor = {
    enable = mkEnableOption "Zed, the high performance, multiplayer code editor from the creators of Atom and Tree-sitter";
  };

  config = mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      package = pkgs.zed-editor;

      extraPackages = with pkgs; [
        alejandra # nix formater
        copilot-language-server
        harper
        nil # nix language server
        nixd # TODO needed because of https://github.com/zed-industries/zed/issues/23368
        rust-analyzer-nightly
        tinymist # lsp for typst
      ];

      extensions = [
        "ansible"
        "crates-lsp"
        "elm"
        "harper"
        "html"
        "java"
        "just"
        "kdl"
        "kotlin"
        "mcp-server-github"
        "neocmake"
        "nix"
        "nu"
        "ruby"
        "scheme"
        "tera"
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
            provider = "copilot_chat";
            # claude-sonnet-4, codestral-latest, gemini-2.5-flash, claude-sonnet-4
            # model = "claude-sonnet-4";
            model = "gpt-4.1";
          };

          inline_assistant_model = {
            provider = "copilot_chat";
            model = "gpt-4.1";
          };

          commit_message_model = {
            provider = "copilot_chat";
            model = "gpt-4.1";
          };

          thread_summary_model = {
            provider = "copilot_chat";
            model = "gpt-4.1";
          };

          default_profile = "ask";
          profiles.ask = {
            name = "Ask";
            enable_all_context_servers = true;

            context_servers.mcp-server-github.tools = {
              add_issue_comment = false;
              add_pull_request_review_comment = false;
              create_branch = false;
              create_issue = false;
              create_or_update_file = false;
              create_pull_request = false;
              create_pull_request_review = false;
              create_repository = false;
              fork_repository = false;
              get_code_scanning_alert = true;
              get_commit = true;
              get_file_contents = true;
              get_issue = true;
              get_issue_comments = true;
              get_me = true;
              get_pull_request = true;
              get_pull_request_comments = true;
              get_pull_request_files = true;
              get_pull_request_reviews = true;
              get_pull_request_status = true;
              get_secret_scanning_alert = true;
              list_branches = true;
              list_code_scanning_alerts = true;
              list_commits = true;
              list_issues = true;
              list_pull_requests = true;
              list_secret_scanning_alerts = true;
              merge_pull_request = false;
              push_files = false;
              search_code = true;
              search_issues = true;
              search_repositories = true;
              search_users = true;
              update_issue = false;
              update_pull_request = false;
              update_pull_request_branch = false;
            };

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
              web_search = true;
            };
          };
        };
        buffer_font_family = "Geist Mono";
        buffer_font_size = 15;
        collaboration_panel.dock = "right";
        context_servers = {
          mcp-server-github =
            let
              github-mcp-server-wrapped = pkgs.writeShellScriptBin "github-mcp-server-wrapped" ''
                export GITHUB_PERSONAL_ACCESS_TOKEN=$(cat /var/secrets/github-mcp-token)
                ${pkgs.github-mcp-server}/bin/github-mcp-server "$@"
              '';
            in
            {
              command = "${github-mcp-server-wrapped}/bin/github-mcp-server-wrapped";
              args = [ "stdio" ];
            };
        };
        edit_predictions.mode = "subtle";
        features = {
          edit_prediction_provider = "copilot"; # zed
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
        # language_models.google.available_models = [
        #   {
        #     name = "gemini-2.5-flash-preview-04-17";
        #     display_name = "Gemini 2.5 Flash Preview";
        #     max_tokens = 1000000;
        #   }
        # ];
        language_models.ollama = {
          api_url = "http://localhost:11434";
          available_models = [ ];
        };
        language_models.openai_compatible.lamma-cpp = {
          api_url = "http://localhost:8030";
          available_models = [ ];
        };
        languages = {
          Kola = {
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
        notification_panel.dock = "left";
        outline_panel.dock = "right";
        preferred_line_length = 120;
        project_panel = {
          dock = "right";
          entry_spacing = "standard";
          indent_guides.show = "never";
        };
        semantic_tokens = "full";
        show_wrap_guides = true;
        soft_wrap = "preferred_line_length";
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
        # base_keymap = "SublimeText";
        # Zed not by defaults look's in the PATH for rust-analyzer
        # lsp = {
        #   rust_analyzer.binary.path_lookup = true;
        # };
      };
    };
  };
}
