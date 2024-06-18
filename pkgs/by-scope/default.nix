self: pkgs: {
  firefoxAddons = import ./firefox-addons self.firefoxAddons pkgs;
  steamPackages = pkgs.steamPackages.overrideScope (_: _: import ./steam-packages self.steamPackages (pkgs // {inherit (self) x86-64-v3Packages;}));
  vscode-extensions = pkgs.lib.recursiveUpdate pkgs.vscode-extensions (import ./vscode-extensions self.vscode-extensions pkgs);
  winPackages = import ./win-packages self.winPackages pkgs;
  x86-64-v3Packages = import ./x86-64-v3-packages self.x86-64-v3Packages pkgs;
}
