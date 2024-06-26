self: pkgs: let
  makeScope = path: scope: (import path (self // scope) pkgs);
in {
  firefoxAddons = makeScope ./firefox-addons self.firefoxAddons;
  intel-dpcpp = makeScope ./intel-dpcpp self.intel-dpcpp;
  intel-llvm = makeScope ./intel-llvm self.intel-llvm;
  intel-python = pkgs.python3.override {
    packageOverrides = pySelf: pyPkgs:
      (import ./intel-python pySelf pyPkgs)
      // {
        # https://github.com/NixOS/nixpkgs/pull/317546
        opencv4 = pySelf.toPythonModule (self.my-opencv.override {
          enablePython = true;
          pythonPackages = pySelf;
        });
      };
  };
  pti-gpu = makeScope ./pti-gpu self.pti-gpu;
  steamPackages = pkgs.steamPackages.overrideScope (_: _: makeScope ./steam-packages self.steamPackages);
  vscode-extensions = pkgs.lib.recursiveUpdate pkgs.vscode-extensions (makeScope ./vscode-extensions self.vscode-extensions);
  winPackages = makeScope ./win-packages self.winPackages;
  x86-64-v3Packages = makeScope ./x86-64-v3-packages self.x86-64-v3Packages;
}
