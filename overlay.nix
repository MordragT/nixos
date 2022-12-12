self: pkgs:
let
  myPkgs = import ./pkgs { inherit pkgs; };
  x86_64-v2 = [
    "-mcx16"
    "-msahf"
    "-mpopcnt"
    "-msse3"
    "-msse4.1"
    "-msse4.2"
    "-mssse3"
  ];
  x86_64-v3 = [
    "-mavx"
    "-mavx2"
    "-mbmi"
    "-mbmi2"
    "-mf16c"
    "-mfma"
    "-mlzcnt"
    "-mmovbe"
    "-mxsave"
  ] ++ x86_64-v2;
  flags = [
    "-flto" # link time optimization
    "-fprofile-generate" # pgo
  ];
in
rec
{
  #stdenv = pkgs.withCFlags (x86_64-v3 ++ flags) pkgs.stdenv;
  clangStdenv = pkgs.withCFlags (x86_64-v3 ++ flags) pkgs.llvmPackages_14.stdenv;
  firefox-unwrapped = pkgs.firefox-unwrapped.override {
    stdenv = clangStdenv;
  };
  # steam-fhsenv = pkgs.steam-fhsenv.overrideAttr (orig: {
  #   extraLibraries = pkgs: with pkgs; [
  #     # Crusader Kings 3
  #     ncurses.lib
  #     gnome.zenity
  #   ];
  # });
  steam = pkgs.steam.override {
    extraLibraries = pkgs: with pkgs; [
      # Crusader Kings 3
      ncurses
      #gnome.zenity
    ];
  };
  python3 = pkgs.python3.override {
    packageOverrides = self: pyPkgs: import ./pkgs/python {
      inherit pyPkgs;
      pkgs = pkgs // myPkgs;
    };
  };
  python3Packages = python3.pkgs;

  dandere2x = pkgs.python3Packages.dandere2x;
} // myPkgs
