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
  #clangStdenv = pkgs.withCFlags (x86_64-v3 ++ flags) pkgs.llvmPackages_14.stdenv;
  # firefox-unwrapped = pkgs.firefox-unwrapped.override {
  #   stdenv = clangStdenv;
  # };
  # steam-fhsenv = pkgs.steam-fhsenv.overrideAttr (orig: {
  #   extraLibraries = pkgs: with pkgs; [
  #     # Crusader Kings 3
  #     ncurses.lib
  #     gnome.zenity
  #   ];
  # });
  libratbag =
    let
      func_ms2 = builtins.readFile ./system/services/ratbag/func-ms2.device;
    in
    pkgs.libratbag.overrideAttrs (old: {
      preFixup = ''
        cp ${./system/services/ratbag/func-ms2.device} $out/share/libratbag/func-ms2.device
      '';
    });
  steam = pkgs.steam.override {
    extraLibraries = pkgs: with pkgs; [
      # Crusader Kings 3
      ncurses
      # gamescope
      libkrb5
      keyutils
      #gnome.zenity
    ];
  };
} // myPkgs
