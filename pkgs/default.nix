{pkgs}: let
  callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.xorg // self);
  self = rec {
    xpuPackages = import ./xpuPackages {inherit pkgs;};

    # astrofox = callPackage ./astrofox.nix { };
    byfl = callPackage ./byfl.nix {};
    cisco-secure-client = callPackage ./cisco-secure-client {};
    dud = callPackage ./dud.nix {};
    ensembles = callPackage ./ensembles.nix {};
    epic-asset-manager = callPackage ./epic-asset-manager {};
    gnome-shell-extension-fly-pie = callPackage ./gnome-extensions/fly-pie.nix {};
    likwid = callPackage ./likwid.nix {};
    lottieconv = callPackage ./lottieconv {};
    oneAPI = callPackage ./oneAPI.nix {};
    oneVPL = callPackage ./oneVPL.nix {inherit oneVPL-intel-gpu;};
    oneVPL-intel-gpu = callPackage ./oneVPL-intel-gpu.nix {};
    opengothic = callPackage ./opengothic.nix {};
    pia-openvpn = callPackage ./pia-openvpn.nix {};
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
