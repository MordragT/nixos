{pkgs}: let
  # callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.xorg // self);
  callPackage = pkgs.callPackage;
  vplPin =
    import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/88add7e28ef9e6610619bac4752a11be0830a0d2.tar.gz";
      sha256 = "1f5kckzrnm523sgcspviwj1a3fyl0i3px9xgap84nzwpz2k34ars";
    }) {
      system = "x86_64-linux";
    };
in rec
{
  xpuPackages = import ./xpuPackages {inherit pkgs;};
  steamPackages = import ./steamPackages {inherit pkgs opengothic;} // pkgs.steamPackages;
  winePackages = import ./winePackages {inherit pkgs;} // pkgs.winePackages;

  # python3 = pkgs.python3.override {
  #   packageOverrides = pySelf: pyPkgs:
  #     import ./python {
  #       inherit pyPkgs;
  #       pkgs = pkgs // {inherit xpuPackages;};
  #     };
  # };
  # python3Packages = python3.pkgs;

  hpcStdenv =
    pkgs.withCFlags [
      # "-flto" # link time optimization
      "-march=x86-64-v3"
      "-O3"
    ]
    pkgs.llvmPackages.stdenv;

  # astrofox = callPackage ./astrofox.nix { };
  byfl = callPackage ./byfl.nix {};
  dud = callPackage ./dud.nix {};
  ensembles = callPackage ./ensembles.nix {};
  epic-asset-manager = callPackage ./epic-asset-manager.nix {};
  lottieconv = callPackage ./lottieconv.nix {};
  opengothic = callPackage ./opengothic.nix {inherit hpcStdenv;};
  spflashtool = callPackage ./spflashtool.nix {};
  tmfs = callPackage ./tmfs.nix {};
  vulkan-raytracing = callPackage ./vulkan-raytracing.nix {};
  webdesigner = callPackage ./webdesigner.nix {};

  llama-cpp = pkgs.llama-cpp.override {
    openclSupport = true;
    blasSupport = false;
  };
  gamescope = pkgs.gamescope_git;
  onevpl-intel-gpu = vplPin.onevpl-intel-gpu;
  ffmpeg-vpl = vplPin.ffmpeg-full.override {
    withVpl = true;
    withMfx = false;
  };
}
