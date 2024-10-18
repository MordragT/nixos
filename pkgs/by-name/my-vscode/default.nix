{vscode}:
vscode.overrideAttrs (old: {
  postInstall = ''
    rm $out/lib/vscode/resources/app/out/vs/code/electron-sandbox/workbench/workbench.esm.html

    cat > $out/lib/vscode/resources/app/out/vs/code/electron-sandbox/workbench/workbench.esm.html << EOF
    <!DOCTYPE html>
      <head>
        <meta charset="utf-8" />
      </head>

      <body aria-label="">
      </body>

      <style>
      ${builtins.readFile ./my-vscode.css}
      </style>

      <!-- Startup (do not modify order of script tags!) -->
      <script src="workbench.js"></script>
      <script>
        <!-- Put here your own custom js -->
      </script>
    </html>

    EOF
  '';
})
