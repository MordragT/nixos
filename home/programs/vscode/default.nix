{ pkgs, vscode-extensions, vscode-utils, ... }:
let
  #css = pkgs.writeText "vscode.css" (builtins.readFile ./vscode.css);
  vscode = pkgs.vscode.overrideAttrs (old: {
    # preInstall = ''
    #   substituteInPlace vs/workbench/electron-sandbox/parts/titlebar/titlebarParts.ts \
    #     --replace "35" "48"
    # '';

    postInstall = ''
      # substituteInPlace $out/lib/vscode/resources/app/out/vs/code/electron-sandbox/workbench/workbench.js \
      #   --replace "\''${t.titleBarHeight}px" "48px"
      
      # substituteInPlace $out/lib/vscode/resources/app/out/vs/workbench/workbench.desktop.main.css \
      #   --replace "return(this.isCommandCenterVisible||c.isWeb&&(0,L.isWCOEnabled)()?35:30)/(this.ub?(0,L.getZoomFactor)():1)"\
      #   "return(this.isCommandCenterVisible||c.isWeb&&(0,L.isWCOEnabled)()?48:48)/(this.ub?(0,L.getZoomFactor)():1)"

      rm $out/lib/vscode/resources/app/out/vs/code/electron-sandbox/workbench/workbench.html

      cat > $out/lib/vscode/resources/app/out/vs/code/electron-sandbox/workbench/workbench.html << EOF
      <!DOCTYPE html>
        <head>
          <meta charset="utf-8" />
        </head>

        <body aria-label="">
        </body>

        <style>
        ${builtins.readFile ./vscode.css}
        </style>

        <!-- Startup (do not modify order of script tags!) -->
        <script src="workbench.js"></script>
        <script>
        ${builtins.readFile ./vscode.js}
        </script>
      </html>

      EOF
    '';
  });
in
{
  programs.vscode = {
    package = vscode;
    enable = true;
    userSettings = {
      "breadcrumbs.enabled" = false;
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
      "editor.occurrencesHighlight" = false;
      "editor.acceptSuggestionOnEnter" = "off";
      "editor.formatOnSave" = true;
      "editor.tabCompletion" = "on";
      "editor.dragAndDrop" = false;
      "editor.lineNumbers" = "interval";
      "editor.renderLineHighlight" = "none";
      "editor.cursorBlinking" = "expand";
      "editor.guides.indentation" = false;

      "explorer.openEditors.visible" = 0;
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;

      "files.exclude" = {
        "**/.classpath" = true;
        "**/.factorypath" = true;
        "**/.idea" = true;
        "**/.project" = true;
        "**/.settings" = true;
        "**/.direnv" = true;
        "**/__pycache__" = true;
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
      "lldb.verboseLogging" = true;
      #"ltex.language" = "de-DE";
      # "latex-workshop.latex.recipes" = [
      #   {
      #     "name" = "tectonic";
      #     "tools" = [ "tectonic" ];      
      #   }    
      # ];
      "python.formatting.provider" = "black";
      #"rust-analyzer.procMacro.enable" = false;
      "terminal.integrated.fontSize" = 11;
      #"terminal.integrated.rendererType" = "dom";

      "window.zoomLevel" = 2;
      "window.menuBarVisibility" = "compact";
      "window.title" = "\${dirty}\${activeEditorShort}\${separator}\${rootName}";
      "window.titleBarStyle" = "custom";
      "window.commandCenter" = true;

      "workbench.activityBar.visible" = true;
      "workbench.tree.indent" = 12;
      "workbench.editor.showTabs" = false;
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
      piousdeer.adwaita-theme
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
      # {
      #   name = "vscode-embedded-tools";
      #   publisher = "ms-vscode";
      #   version = "0.7.230323001";
      #   sha256 = "1hm47gvhb510lhqarryhjsh8gzfpxnzhiyv16d63999f4fli5sqv";
      # }
      {
        name = "vscode-zig";
        publisher = "ziglang";
        version = "0.3.1";
        sha256 = "17k2jk1yfhsxysmp6kj6xyljvnjgqx38l2a2b1aa0syafv8iqzvk";
      }
      {
        name = "typst-lsp";
        publisher = "nvarner";
        version = "0.2.0";
        sha256 = "KXd2jYzin6C5QeAogQjcNn1HqbanfrYLCc+sB5yX0Iw=";
      }
    ];
  };
}
