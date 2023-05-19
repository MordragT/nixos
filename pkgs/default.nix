{ pkgs }:
let
  callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.xorg // self);
  self = rec {
    grass = callPackage ./grass { };
    lottieconv = callPackage ./lottieconv { };
    superview = callPackage ./superview { };
    # astrofox = callPackage ./astrofox.nix { };
    epic-asset-manager = callPackage ./epic-asset-manager { };
    spflashtool = callPackage ./spflashtool.nix { };
    webdesigner = callPackage ./webdesigner.nix { };
    # webex = callPackage ./webex.nix { };
    focalboard = callPackage ./focalboard.nix { };
    gnome-shell-extension-fly-pie = callPackage ./gnome-extensions/fly-pie.nix { };
    webcamoid = pkgs.libsForQt5.callPackage ./webcamoid.nix { };
    oneapi = callPackage ./oneapi.nix { };
    likwid = callPackage ./likwid.nix { };
    byfl = callPackage ./byfl.nix { };
    #dvc = callPackage ./dvc.nix { };
    ensembles = callPackage ./ensembles.nix { };
  };
  python3 = pkgs.python3.override {
    packageOverrides = pySelf: pyPkgs: import ./python {
      inherit pyPkgs;
      pkgs = pkgs // self;
    };
  };
in
self // {
  python3 = python3;
  python3Packages = python3.pkgs;
}

