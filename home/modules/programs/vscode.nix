{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.programs.vscode;
in {
  options.mordrag.programs.vscode = {
    enable = lib.mkEnableOption "VSCode";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      typst-lsp
      black
      # platformio-core

      # nickel support
      nickel
      nls
      topiary
    ];

    programs.vscode = {
      package = pkgs.my-vscode;
      enable = true;
      userSettings = {
        "breadcrumbs.enabled" = false;
        "cSpell.language" = "en,de";
        "cSpell.enableFiletypes" = ["typst"];
        "debug.allowBreakpointsEverywhere" = true;
        "debug.showBreakpointsInOverviewRuler" = true;

        "editor.minimap.enabled" = false;
        "editor.minimap.scale" = 2;
        "editor.fontLigatures" = true;
        "editor.fontFamily" = "'Jetbrains Mono', 'monospace', monospace, 'Droid Sans Fallback'";
        "editor.fontSize" = 11;
        "editor.renderWhitespace" = "none";
        "editor.folding" = false;
        "editor.glyphMargin" = true;
        "editor.occurrencesHighlight" = "off";
        "editor.acceptSuggestionOnEnter" = "off";
        "editor.formatOnSave" = true;
        "editor.tabCompletion" = "on";
        "editor.dragAndDrop" = false;
        "editor.lineNumbers" = "interval";
        "editor.renderLineHighlight" = "none";
        "editor.cursorBlinking" = "expand";
        "editor.guides.indentation" = false;

        "explorer.openEditors.visible" = 1;
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;

        "extensions.autoUpdate" = false;

        "files.exclude" = {
          "**/.classpath" = true;
          "**/.factorypath" = true;
          "**/.idea" = true;
          "**/.project" = true;
          "**/.settings" = true;
          "**/.direnv" = true;
          "**/__pycache__" = true;
          "**/.venv" = true;
        };
        "files.associations" = {
          "*.lalrpop" = "rust";
          "*.tera" = "html";
        };

        "git.enableSmartCommit" = true;
        "git.autofetch" = true;
        "http.proxySupport" = "off";
        #"java.import.gradle.wrapper.enabled" = false;
        "jupyter.allowUnauthorizedRemoteConnection" = true;
        "kotlin.java.home" = "$JAVA_HOME";
        # "lldb.verboseLogging" = true;
        # "ltex.language" = "de-DE";
        # "latex-workshop.latex.recipes" = [
        #   {
        #     "name" = "tectonic";
        #     "tools" = [ "tectonic" ];
        #   }
        # ];

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";

        # "platformio-ide.customPATH" = "/nix/store/9ak4j7mjxxqwp85a0dwa381acx3i5zrz-platformio-fhs";
        # "platformio-ide.useBuiltinPIOCore" = false;
        # "platformio-ide.useBuiltinPython" = false;
        # "platformio-ide.pioHomeServerHttpHost" = "0.0.0.0";

        # "python.formatting.provider" = "black";
        "rust-analyzer.procMacro.enable" = false;
        "terminal.integrated.fontSize" = 11;
        # "terminal.integrated.rendererType" = "dom";
        "typst-lsp.exportPdf" = "never";
        # "typst-lsp.serverPath" = "${pkgs.typst-lsp}/bin/typst-lsp";
        "window.zoomLevel" = 2;
        "window.menuBarVisibility" = "compact";
        "window.title" = "\${dirty}\${activeEditorShort}\${separator}\${rootName}";
        "window.titleBarStyle" = "custom";
        "window.commandCenter" = true;

        # "workbench.activityBar.visible" = true;
        "workbench.tree.indent" = 12;
        "workbench.editor.showTabs" = "single";
        "workbench.statusBar.visible" = true;
        "workbench.sideBar.location" = "right";
        "workbench.editor.showIcons" = false;
        "workbench.colorTheme" = "Monokai";
        "workbench.startupEditor" = "newUntitledFile";
        "workbench.tree.renderIndentGuides" = "none";
        "workbench.productIconTheme" = "adwaita";
        "workbench.editor.labelFormat" = "short";
      };
      keybindings = [
        {
          key = "ctrl+k ctrl+e";
          command = "workbench.view.explorer";
        }
        {
          key = "ctrl+k ctrl+v";
          command = "workbench.view.scm";
        }
        {
          key = "ctrl+k ctrl+d";
          command = "workbench.view.debug";
        }
        {
          key = "ctrl+k ctrl+x";
          command = "workbench.extensions.action.showInstalledExtensions";
        }
        {
          key = "ctrl+n";
          command = "explorer.newFile";
          when = "explorerViewletVisible && filesExplorerFocus && !inputFocus";
        }
        {
          key = "shift+ctrl+n";
          command = "explorer.newFolder";
          when = "explorerViewletVisible && filesExplorerFocus && !inputFocus";
        }
        {
          key = "ctrl+r";
          command = "workbench.files.action.refreshFilesExplorer";
          when = "explorerViewletVisible && filesExplorerFocus && !inputFocus";
        }
      ];
      mutableExtensionsDir = true;
      extensions = with pkgs.vscode-extensions; [
        bierner.markdown-mermaid
        bmewburn.vscode-intelephense-client
        # catppuccin.catppuccin-vsc
        cesium.gltf-vscode
        davidanson.vscode-markdownlint
        firefox-devtools.vscode-firefox-debug
        fwcd.kotlin
        gruntfuggly.todo-tree
        jnoortheen.nix-ide
        jsinger67.parol-vscode
        kamadorueda.alejandra
        marp-team.marp-vscode
        matangover.mypy
        Mordrag.one-dark-vibrant

        ms-python.python
        ms-python.vscode-pylance
        ms-dotnettools.csharp
        ms-toolsai.jupyter
        ms-toolsai.jupyter-renderers
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.vscode-jupyter-slideshow
        ms-vscode.cmake-tools
        ms-vscode.cpptools
        ms-vscode.sublime-keybindings
        # ms-vscode-remote.remote-ssh
        # ms-vsliveshare.vsliveshare

        mgt19937.typst-preview
        nvarner.typst-lsp
        piousdeer.adwaita-theme
        PolyMeilex.wgsl
        redhat.java
        rust-lang.rust-analyzer-nightly
        skellock.just
        streetsidesoftware.code-spell-checker
        streetsidesoftware.code-spell-checker-german
        svelte.svelte-vscode
        tamasfe.even-better-toml
        thenuprojectcontributors.vscode-nushell-lang
        tomoki1207.pdf
        twxs.cmake

        # vadimcn.vscode-lldb
        # valentjn.vscode-ltex
        vscjava.vscode-gradle
        yzhang.markdown-all-in-one
        ziglang.vscode-zig
      ];
    };
  };
}
