{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.programs.vscode;
in
{
  options.mordrag.programs.vscode = {
    enable = lib.mkEnableOption "VSCode";
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      package = pkgs.vscodium;
      enable = true;
      mutableExtensionsDir = false;

      profiles.default = {
        userSettings = {
          "breadcrumbs.enabled" = false;
          "debug.allowBreakpointsEverywhere" = true;
          "debug.showBreakpointsInOverviewRuler" = true;

          "editor.minimap.enabled" = false;
          "editor.minimap.scale" = 2;
          "editor.fontLigatures" = true;
          "editor.fontFamily" = "'Geist Mono'";
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
            "**/.idea" = true;
            "**/.direnv" = true;
          };
          "files.associations" = {
            "*.tera" = "html";
          };

          "git.enableSmartCommit" = true;
          "git.autofetch" = true;
          "http.proxySupport" = "off";

          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil";

          "rust-analyzer.procMacro.enable" = false;
          "terminal.integrated.fontSize" = 11;
          "window.zoomLevel" = 2;
          "window.menuBarVisibility" = "compact";
          "window.title" = "\${dirty}\${activeEditorShort}\${separator}\${rootName}";
          "window.titleBarStyle" = "custom";
          "window.commandCenter" = true;

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
        extensions = with pkgs.vscode-extensions; [
          antfu.slidev
          bierner.markdown-mermaid
          kamadorueda.alejandra
          matangover.mypy
          Mordrag.one-dark-vibrant

          ms-python.python
          ms-python.vscode-pylance
          ms-dotnettools.csharp
          ms-toolsai.jupyter
          ms-toolsai.jupyter-renderers
          ms-toolsai.vscode-jupyter-cell-tags
          ms-toolsai.vscode-jupyter-slideshow
          ms-vscode.cpptools
          ms-vscode.sublime-keybindings

          myriad-dreamin.tinymist
          piousdeer.adwaita-theme
          skellock.just
          tamasfe.even-better-toml
          thenuprojectcontributors.vscode-nushell-lang
          tomoki1207.pdf
        ];
      };
    };
  };
}
