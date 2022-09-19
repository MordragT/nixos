{ vscode-extensions, vscode-utils, fenix, ... }:
{
  programs.vscode = {
    enable = true;
    userSettings = {
      "window.zoomLevel" = 0;
      "editor.minimap.enabled" = false;
      "editor.fontLigatures" = true;
      "editor.fontFamily" = "'Jetbrains Mono', 'monospace', monospace, 'Droid Sans Fallback'";
      "editor.fontSize" = 14;
      "terminal.integrated.fontSize" = 14;
      "editor.renderWhitespace" = "none";
      "editor.folding" = false;
      "editor.glyphMargin" = true;
      "explorer.openEditors.visible" = 0;
      "workbench.activityBar.visible" = true;
      "workbench.editor.showTabs" = false;
      "workbench.statusBar.visible" = true;
      "workbench.sideBar.location" = "right";
      "workbench.editor.showIcons" = false;
      "workbench.colorTheme" = "One Dark Vibrant";
      "editor.occurrencesHighlight" = false;
      "workbench.startupEditor" = "newUntitledFile";
      "workbench.tree.renderIndentGuides" = "none";
      "editor.acceptSuggestionOnEnter" = "off";
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      # "editor.renderIndentGuides" = false;
      "editor.formatOnSave" = true;
      "terminal.integrated.rendererType" = "dom";
      "git.enableSmartCommit" = true;
      "git.autofetch" = true;
      "editor.tabCompletion" = "on";
      "editor.dragAndDrop" = false;
      "editor.lineNumbers" = "interval";
      "editor.renderLineHighlight" = "none";
      "editor.cursorBlinking" = "expand";
      "files.exclude" = {
        "**/.classpath" = true;
        "**/.factorypath" = true;
        "**/.idea" = true;
        "**/.project" = true;
        "**/.settings" = true;
      };
      "breadcrumbs.enabled" = false;
      "workbench.editor.labelFormat" = "short";
      "window.menuBarVisibility" = "toggle";
      "window.title" = "\${dirty}\${activeEditorShort}\${separator}\${rootName}";
      "debug.allowBreakpointsEverywhere" = true;
      "debug.showBreakpointsInOverviewRuler" = true;
      "rust-analyzer.procMacro.enable" = false;
      "lldb.verboseLogging" = true;
      "files.associations" = {
        "*.lalrpop" = "rust";
        "*.tera" = "html";
      };
      "ltex.language" = "de-DE";
      # "latex-workshop.latex.recipes" = [
      #   {
      #     "name" = "tectonic";
      #     "tools" = [ "tectonic" ];      
      #   }    
      # ];
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
    extensions = with vscode-extensions; [
      fenix.rust-analyzer-vscode-extension
      # vadimcn.vscode-lldb
      ms-toolsai.jupyter
      ms-python.python
      ms-vscode-remote.remote-ssh
      ms-vsliveshare.vsliveshare
      # bbenoist.nix
      bungcip.better-toml
      tiehuis.zig
      # ms-vscode.cpptools
      xaver.clang-format
      gruntfuggly.todo-tree
      # james-yu.latex-workshop
      skellock.just
      jnoortheen.nix-ide
      # arrterian.nix-env-selector
      valentjn.vscode-ltex
    ] ++ vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "texlab";
        publisher = "efoerster";
        version = "4.0.0";
        sha256 = "0bR/SPi4NkHT0GRaHyuT2A1f3vjRkhVH7wXcKq3LsEE=";
      }
      {
        name = "vscode-intelephense-client";
        publisher = "bmewburn";
        version = "1.8.2";
        sha256 = "1sla3pl3jfdawjmscwf2ml42xhwjaa9ywdgdpl6v99p10w6rvx9s";
      }
      {
        name = "flowistry";
        publisher = "wcrichton";
        version = "0.5.27";
        sha256 = "1rhp32az7smzhdc6gbz546v0l0507pmhw9y7zsdw43hb5sh1ykj7";
      }
      {
        name = "one-dark-vibrant";
        publisher = "Mordrag";
        version = "0.0.4";
        sha256 = "0wd3ik6aspmdbylwshbkw2cmckyyf6n98d3anai5mvwyvidfymwb";
      }
    ];
  };
}
