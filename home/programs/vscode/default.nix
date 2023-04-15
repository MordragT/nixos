{ pkgs, ... }:
let
  vscode = pkgs.vscode.overrideAttrs (old: {
    postInstall = ''
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
  home.packages = with pkgs; [
    typst-lsp
    rnix-lsp
    black
    platformio-core
  ];

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

      "nix.enableLanguageServer" = true;

      #"platformio-ide.customPATH" = "/nix/store/9ak4j7mjxxqwp85a0dwa381acx3i5zrz-platformio-fhs";
      "platformio-ide.useBuiltinPIOCore" = false;
      "platformio-ide.useBuiltinPython" = false;
      #"platformio-ide.pioHomeServerHttpHost" = "0.0.0.0";

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
    extensions = with pkgs.vscode-extensions; [
      # arrterian.nix-env-selector
      # bbenoist.nix
      bierner.markdown-mermaid
      bmewburn.vscode-intelephense-client
      bungcip.better-toml
      catppuccin.catppuccin-vsc
      firefox-devtools.vscode-firefox-debug
      gruntfuggly.todo-tree
      # james-yu.latex-workshop
      jnoortheen.nix-ide
      matangover.mypy

      ms-python.python
      ms-toolsai.jupyter
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.vscode-jupyter-slideshow
      ms-vscode.cmake-tools
      ms-vscode.cpptools
      ms-vscode-remote.remote-ssh
      ms-vsliveshare.vsliveshare

      nvarner.typst-lsp
      piousdeer.adwaita-theme
      redhat.java
      rust-lang.rust-analyzer-nightly
      skellock.just
      svelte.svelte-vscode
      thenuprojectcontributors.vscode-nushell-lang
      twxs.cmake

      vadimcn.vscode-lldb
      valentjn.vscode-ltex
      vscjava.vscode-gradle
      yzhang.markdown-all-in-one

    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "texlab";
        publisher = "efoerster";
        version = "4.2.2";
        sha256 = "KEXy5FQIBRZXrR6rcdcWEG2qM1B9ricY3W+H0R+HBM4=";
      }
      # {
      #   name = "flowistry";
      #   publisher = "wcrichton";
      #   version = "0.5.28";
      #   sha256 = "1r232zcbqd7fs1nbjj4c4iwnw1z18b6ms2has74i97xrx17jhmqk";
      # }
      {
        name = "gltf-vscode";
        publisher = "cesium";
        version = "2.3.16";
        sha256 = "02xd6vzy5a9q5cs5pwzr8cli28lbs4vaqq3r2ljzcgbwds45f83a";
      }
      {
        name = "kotlin";
        publisher = "fwcd";
        version = "0.2.26";
        sha256 = "1br0vr4v1xcl4c7bcqwzfqd4xr6q2ajwkipqrwm928mj96dkafkn";
      }
      {
        name = "one-dark-vibrant";
        publisher = "Mordrag";
        version = "0.0.4";
        sha256 = "0wd3ik6aspmdbylwshbkw2cmckyyf6n98d3anai5mvwyvidfymwb";
      }
      {
        name = "platformio-ide";
        publisher = "platformio";
        version = "3.1.1";
        sha256 = "fwEct7Tj8bfTOLRozSZJGWoLzWRSvYz/KxcnfpO8Usg=";
      }
      {
        name = "sublime-keybindings";
        publisher = "ms-vscode";
        version = "4.0.10";
        sha256 = "0l8z0sv3432qrzh6118km7xr7g93fajmjihw8md47kfsdl9c4xxg";
      }

      {
        name = "wgsl";
        publisher = "PolyMeilex";
        version = "0.1.12";
        sha256 = "1m1j9fi85fjjyx2ws9d7vnmn8g22sxhrk27diazy34mp2p4dr8jd";
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
    ];
  };
}
