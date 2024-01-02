{pkgs}: let
  callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.xorg // self);
  self = rec {
    lottieconv = callPackage ./lottieconv {};
    superview = callPackage ./superview {};
    # astrofox = callPackage ./astrofox.nix { };
    cisco-secure-client = callPackage ./cisco-secure-client {};
    epic-asset-manager = callPackage ./epic-asset-manager {};
    spflashtool = callPackage ./spflashtool.nix {};
    webdesigner = callPackage ./webdesigner.nix {};
    gnome-shell-extension-fly-pie = callPackage ./gnome-extensions/fly-pie.nix {};
    likwid = callPackage ./likwid.nix {};
    byfl = callPackage ./byfl.nix {};
    ensembles = callPackage ./ensembles.nix {};
    tmfs = callPackage ./tmfs.nix {};
    oneAPI = callPackage ./oneAPI.nix {};
    oneVPL = callPackage ./oneVPL.nix {inherit oneVPL-intel-gpu;};
    oneVPL-intel-gpu = callPackage ./oneVPL-intel-gpu.nix {};
    pia-openvpn = callPackage ./pia-openvpn.nix {};
    xpuPackages = import ./xpuPackages {inherit callPackage;};
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
