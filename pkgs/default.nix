{ pkgs }:
let
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
  self = rec {
    grass = callPackage ./grass { };
    lottieconv = callPackage ./lottieconv { };
    superview = callPackage ./superview { };
    astrofox = callPackage ./astrofox.nix { };
    spflashtool = callPackage ./spflashtool.nix { };
    webdesigner = callPackage ./webdesigner.nix { };
    webex = callPackage ./webex.nix { };
    focalboard = callPackage ./focalboard.nix { };
    gnome-shell-extension-fly-pie = callPackage ./gnome-extensions/fly-pie.nix { };
  };
in
self

