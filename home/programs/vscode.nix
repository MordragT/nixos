{ vscode-extensions, vscode-utils, ... }:
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
        "**/.direnv" = true;
        "**/__pycache__" = true;
      };
      "breadcrumbs.enabled" = false;
      "workbench.editor.labelFormat" = "short";
      "window.menuBarVisibility" = "toggle";
      "window.title" = "\${dirty}\${activeEditorShort}\${separator}\${rootName}";
      "debug.allowBreakpointsEverywhere" = true;
      "debug.showBreakpointsInOverviewRuler" = true;
      "lldb.verboseLogging" = true;
      "files.associations" = {
        "*.lalrpop" = "rust";
        "*.tera" = "html";
      };
      "jupyter.allowUnauthorizedRemoteConnection" = true;
      "http.proxySupport" = "off";
      #"rust-analyzer.procMacro.enable" = false;
      #"ltex.language" = "de-DE";
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
    #mutableExtensionsDir = false;
    extensions = with vscode-extensions; [
      rust-lang.rust-analyzer-nightly
      redhat.java
      vadimcn.vscode-lldb
      ms-toolsai.jupyter
      ms-python.python
      matangover.mypy
      ms-vscode-remote.remote-ssh
      ms-vscode.cpptools
      # ms-vsliveshare.vsliveshare
      ms-vscode.cmake-tools
      twxs.cmake
      bungcip.better-toml
      tiehuis.zig
      gruntfuggly.todo-tree
      skellock.just
      jnoortheen.nix-ide
      # bbenoist.nix
      # arrterian.nix-env-selector
      valentjn.vscode-ltex
      # james-yu.latex-workshop
      svelte.svelte-vscode
      yzhang.markdown-all-in-one
      bierner.markdown-mermaid
      thenuprojectcontributors.vscode-nushell-lang
      catppuccin.catppuccin-vsc
    ] ++ vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "texlab";
        publisher = "efoerster";
        version = "4.2.2";
        sha256 = "KEXy5FQIBRZXrR6rcdcWEG2qM1B9ricY3W+H0R+HBM4=";
      }
      {
        name = "vscode-intelephense-client";
        publisher = "bmewburn";
        version = "1.8.2";
        sha256 = "1sla3pl3jfdawjmscwf2ml42xhwjaa9ywdgdpl6v99p10w6rvx9s";
      }
      # {
      #   name = "flowistry";
      #   publisher = "wcrichton";
      #   version = "0.5.28";
      #   sha256 = "1r232zcbqd7fs1nbjj4c4iwnw1z18b6ms2has74i97xrx17jhmqk";
      # }
      {
        name = "one-dark-vibrant";
        publisher = "Mordrag";
        version = "0.0.4";
        sha256 = "0wd3ik6aspmdbylwshbkw2cmckyyf6n98d3anai5mvwyvidfymwb";
      }
      {
        name = "gltf-vscode";
        publisher = "cesium";
        version = "2.3.16";
        sha256 = "02xd6vzy5a9q5cs5pwzr8cli28lbs4vaqq3r2ljzcgbwds45f83a";
      }
      {
        name = "wgsl";
        publisher = "PolyMeilex";
        version = "0.1.12";
        sha256 = "1m1j9fi85fjjyx2ws9d7vnmn8g22sxhrk27diazy34mp2p4dr8jd";
      }
      {
        name = "sublime-keybindings";
        publisher = "ms-vscode";
        version = "4.0.10";
        sha256 = "0l8z0sv3432qrzh6118km7xr7g93fajmjihw8md47kfsdl9c4xxg";
      }
      {
        name = "vscode-jupyter-cell-tags";
        publisher = "ms-toolsai";
        version = "0.1.3";
        sha256 = "12kwpda0bf5zvhkm9bbjmzdj2lcw6674bbscmbilyzqcz730zyrr";
      }
      {
        name = "vscode-jupyter-slideshow";
        publisher = "ms-toolsai";
        version = "0.1.3";
        sha256 = "04ibh7ddzhdcvl6wa9lzrp84l41zczcxqlz1dfp3b7mz130pr1x7";
      }
      {
        name = "kotlin";
        publisher = "fwcd";
        version = "0.2.26";
        sha256 = "1br0vr4v1xcl4c7bcqwzfqd4xr6q2ajwkipqrwm928mj96dkafkn";
      }
      {
        name = "vscode-gradle";
        publisher = "vscjava";
        version = "3.12.2022092700";
        sha256 = "00pmfmbzqfqp49li0ykxaji04frn1xfshpk9wz3ib8csdzhs7wzm";
      }
    ];
  };
}
