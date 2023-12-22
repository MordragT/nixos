self: pkgs: let
  myPkgs = import ./pkgs {inherit pkgs;};
  # x86_64-v2 = [
  #   "-mcx16"
  #   "-msahf"
  #   "-mpopcnt"
  #   "-msse3"
  #   "-msse4.1"
  #   "-msse4.2"
  #   "-mssse3"
  # ];
  # x86_64-v3 =
  #   [
  #     "-mavx"
  #     "-mavx2"
  #     "-mbmi"
  #     "-mbmi2"
  #     "-mf16c"
  #     "-mfma"
  #     "-mlzcnt"
  #     "-mmovbe"
  #     "-mxsave"
  #   ]
  #   ++ x86_64-v2;
  # flags = [
  #   "-flto" # link time optimization
  #   "-fprofile-generate" # pgo
  # ];
in
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
    llama-cpp = pkgs.llama-cpp.override {
      openclSupport = true;
      openblasSupport = false;
    };
  }
  // myPkgs
