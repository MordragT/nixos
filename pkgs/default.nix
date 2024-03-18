{pkgs}: let
  # callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.xorg // self);
  callPackage = pkgs.callPackage;
in rec
{
  xpuPackages = import ./xpuPackages {inherit pkgs;};
  compatPackages = import ./compatPackages {inherit pkgs opengothic;};

  python3 = pkgs.python3.override {
    packageOverrides = pySelf: pyPkgs:
      import ./python {
        inherit pyPkgs;
        pkgs = pkgs // {inherit xpuPackages;};
      };
  };
  python3Packages = python3.pkgs;

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
  epic-asset-manager = callPackage ./epic-asset-manager {};
  lottieconv = callPackage ./lottieconv {};
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
}
