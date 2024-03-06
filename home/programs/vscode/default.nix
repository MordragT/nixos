{pkgs, ...}: let
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
in {
  home.packages = with pkgs; [
    typst-lsp
    black
    platformio-core
  ];

  programs.vscode = {
    package = vscode;
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
    extensions = with pkgs.vscode-extensions;
      [
        bierner.markdown-mermaid
        bmewburn.vscode-intelephense-client
        # catppuccin.catppuccin-vsc
        davidanson.vscode-markdownlint
        firefox-devtools.vscode-firefox-debug
        gruntfuggly.todo-tree
        jnoortheen.nix-ide
        kamadorueda.alejandra
        marp-team.marp-vscode
        matangover.mypy

        ms-python.python
        ms-python.vscode-pylance
        ms-dotnettools.csharp
        ms-toolsai.jupyter
        ms-toolsai.jupyter-renderers
        ms-toolsai.vscode-jupyter-cell-tags
        ms-toolsai.vscode-jupyter-slideshow
        ms-vscode.cmake-tools
        ms-vscode.cpptools
        # ms-vscode-remote.remote-ssh
        # ms-vsliveshare.vsliveshare

        mgt19937.typst-preview
        nvarner.typst-lsp
        piousdeer.adwaita-theme
        redhat.java
        rust-lang.rust-analyzer-nightly
        skellock.just
        streetsidesoftware.code-spell-checker
        svelte.svelte-vscode
        tamasfe.even-better-toml
        thenuprojectcontributors.vscode-nushell-lang
        twxs.cmake

        # vadimcn.vscode-lldb
        # valentjn.vscode-ltex
        vscjava.vscode-gradle
        yzhang.markdown-all-in-one
        ziglang.vscode-zig
      ]
      ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "code-spell-checker-german";
          publisher = "streetsidesoftware";
          version = "2.3.1";
          sha256 = "0dxqslksj1l27lq8fc083w1nhipd9gd70na7469bz4s65asiy61g";
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
          version = "2.4.0";
          sha256 = "0yvhnriwryxz37n89wphmy51r0r7p7q8jg6nz4wq7824lvb8hbyh";
        }
        {
          name = "kotlin";
          publisher = "fwcd";
          version = "0.2.34";
          sha256 = "12d7nmbzpfaqif86hxw6qq3jv7q77h0b7mbn41y3rx80f9q7lwfk";
        }
        {
          name = "one-dark-vibrant";
          publisher = "Mordrag";
          version = "0.0.4";
          sha256 = "0wd3ik6aspmdbylwshbkw2cmckyyf6n98d3anai5mvwyvidfymwb";
        }
        {
          name = "parol-vscode";
          publisher = "jsinger67";
          version = "0.1.15";
          sha256 = "1y2fixz4jazac384wqv84grn0wbgq5n0jfw4hrdiv54gziqqf964";
        }
        # {
        #   name = "platformio-ide";
        #   publisher = "platformio";
        #   version = "3.1.1";
        #   sha256 = "fwEct7Tj8bfTOLRozSZJGWoLzWRSvYz/KxcnfpO8Usg=";
        # }
        {
          name = "sublime-keybindings";
          publisher = "ms-vscode";
          version = "4.0.10";
          sha256 = "0l8z0sv3432qrzh6118km7xr7g93fajmjihw8md47kfsdl9c4xxg";
        }
        {
          name = "texlab";
          publisher = "efoerster";
          version = "5.12.1";
          sha256 = "0kkbqjiamkx2yrpdlw7mi5m34vqdxyavhc1aii85fkxjifpy0vf0";
        }
        {
          name = "wgsl";
          publisher = "PolyMeilex";
          version = "0.1.16";
          sha256 = "1fb4vqp5l1qgvhpgasivar05p71kcgkka4xy0y87gfvw8griaiyh";
        }
        # {
        #   name = "vscode-embedded-tools";
        #   publisher = "ms-vscode";
        #   version = "0.7.230323001";
        #   sha256 = "1hm47gvhb510lhqarryhjsh8gzfpxnzhiyv16d63999f4fli5sqv";
        # }
      ];
  };
}
