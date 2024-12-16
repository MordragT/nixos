self: pkgs: let
  makeScope = path: scope: (import path (self // scope) pkgs);
in {
  firefoxAddons = makeScope ./firefox-addons self.firefoxAddons;
  intel-dpcpp = makeScope ./intel-dpcpp self.intel-dpcpp;
  intel-python = pkgs.python311.override {
    packageOverrides = import ./intel-python;
  };
  intel-sycl = makeScope ./intel-sycl self.intel-sycl;
  pti-gpu = makeScope ./pti-gpu self.pti-gpu;
  # steamPackages = pkgs.steamPackages.overrideScope (_: _: makeScope ./steam-packages self.steamPackages);
  vscode-extensions = pkgs.lib.recursiveUpdate pkgs.vscode-extensions (makeScope ./vscode-extensions self.vscode-extensions);
}
