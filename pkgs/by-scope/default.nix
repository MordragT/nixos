self: pkgs: let
  makeScope = path: scope: (import path (self // scope) pkgs);
in {
  firefoxAddons = makeScope ./firefox-addons self.firefoxAddons;
  intel-dpcpp = makeScope ./intel-dpcpp self.intel-dpcpp;
  intel-llvm = makeScope ./intel-llvm self.intel-llvm;
  intel-llvm-bin = makeScope ./intel-llvm-bin self.intel-llvm-bin;
  intel-python = pkgs.python311.override {
    packageOverrides = import ./intel-python;
  };
  pti-gpu = makeScope ./pti-gpu self.pti-gpu;
  # steamPackages = pkgs.steamPackages.overrideScope (_: _: makeScope ./steam-packages self.steamPackages);
  vscode-extensions = pkgs.lib.recursiveUpdate pkgs.vscode-extensions (makeScope ./vscode-extensions self.vscode-extensions);
}
