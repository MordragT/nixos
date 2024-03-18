{pkgs}: let
  callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.xorg // self);
  self = rec {
    xpuPackages = import ./xpuPackages {inherit pkgs;};
    compatPackages = import ./compatPackages {inherit pkgs opengothic;};

    # astrofox = callPackage ./astrofox.nix { };
    byfl = callPackage ./byfl.nix {};
    cisco-secure-client = callPackage ./cisco-secure-client {};
    dud = callPackage ./dud.nix {};
    ensembles = callPackage ./ensembles.nix {};
    epic-asset-manager = callPackage ./epic-asset-manager {};
    lottieconv = callPackage ./lottieconv {};
    oneAPI = callPackage ./oneAPI.nix {};
    oneVPL = callPackage ./oneVPL.nix {inherit oneVPL-intel-gpu;};
    oneVPL-intel-gpu = callPackage ./oneVPL-intel-gpu.nix {};
    opengothic = callPackage ./opengothic.nix {};
    spflashtool = callPackage ./spflashtool.nix {};
    tmfs = callPackage ./tmfs.nix {};
    vulkan-raytracing = callPackage ./vulkan-raytracing.nix {};
    webdesigner = callPackage ./webdesigner.nix {};
  };
  python3 = pkgs.python3.override {
    packageOverrides = pySelf: pyPkgs:
      import ./python {
        inherit pyPkgs;
        pkgs = pkgs // self;
      };
  };
in
  self
  // {
    python3 = python3;
    python3Packages = python3.pkgs;
  }
