self: pkgs: let
  pins = import ./pins.nix {inherit (self) system;};
  packages = import ./packages self pkgs;
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
    intelPackages = import ./intel-packages self pkgs;
    oneapiPackages = import ./oneapi-packages self pkgs;
    steamPackages = pkgs.steamPackages.overrideScope (_: _: import ./steam-packages self pkgs);
    winPackages = import ./win-packages self pkgs;
    x86-64-v3Packages = import ./x86-64-v3-packages self pkgs;
    xpuPackages = import ./xpu-packages self pkgs;
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
