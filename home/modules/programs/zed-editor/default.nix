{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mordrag.programs.zed-editor;
  jsonFormat = pkgs.formats.json {};

  mergedSettings =
    cfg.userSettings
    // {
      # this part by @cmacrae
      auto_install_extensions =
        lib.listToAttrs
        (map (ext: lib.nameValuePair ext true) cfg.extensions);
    };
in {
  options.mordrag.programs.zed-editor = {
    enable =
      mkEnableOption
      "Zed, the high performance, multiplayer code editor from the creators of Atom and Tree-sitter";
    package = mkPackageOption pkgs "zed-editor" {};

    userSettings = mkOption {
      type = jsonFormat.type;
      default = {
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
      description = ''
        Configuration written to Zed's {file}`settings.json`.
      '';
    };

    userKeymaps = mkOption {
      type = jsonFormat.type;
      default = {};
      description = ''
        Configuration written to Zed's {file}`keymap.json`.
      '';
    };

    extensions = mkOption {
      type = types.listOf types.str;
      default = [
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
      description = ''
        A list of the extensions Zed should install on startup.
        Use the name of a repository in the [extension list](https://github.com/zed-industries/extensions/tree/main/extensions).
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];
    xdg.configFile."zed/settings.json" = mkIf (mergedSettings != {}) {
      source = jsonFormat.generate "zed-user-settings" mergedSettings;
    };
    xdg.configFile."zed/keymap.json" = mkIf (cfg.userKeymaps != {}) {
      source = jsonFormat.generate "zed-user-keymaps" cfg.userKeymaps;
    };
  };
}
