self: pkgs: let
  pins = import ./pins.nix {inherit (self) system;};
  packages = import ./packages packages pkgs;
in
  packages
  // {
    # Pinned packages
    onevpl-intel-gpu = pins.vpl.onevpl-intel-gpu;
    ffmpeg-vpl = pins.vpl.ffmpeg-full.override {
      withVpl = true;
      withMfx = false;
    };

    # Namespaced packages
    firefoxAddons = import ./firefox-addons self.firefoxAddons pkgs;
    intelPackages = import ./intel-packages self.intelPackages pkgs;
    oneapiPackages = import ./oneapi-packages self.oneapiPackages (pkgs // {inherit (self) intelPackages;});
    steamPackages = pkgs.steamPackages.overrideScope (_: _: import ./steam-packages self.steamPackages (pkgs // {inherit (self) x86-64-v3Packages;}));
    winPackages = import ./win-packages self.winPackages pkgs;
    x86-64-v3Packages = import ./x86-64-v3-packages self.x86-64-v3Packages pkgs;
    xpuPackages = import ./xpu-packages self.xpuPackages pkgs;
    python3 = pkgs.python3.override {
      packageOverrides = pySelf: pyPkgs:
        import ./python-packages pySelf pyPkgs;
    };
    python3Packages = self.python3.pkgs;

    # Overrides
    llama-cpp = pkgs.llama-cpp.override {
      openclSupport = true;
      blasSupport = false;
    };
    gamescope = pkgs.gamescope_git;
  }
