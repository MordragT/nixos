self: pkgs: let
  pins = import ./pins.nix {inherit (pkgs) system;};
  build-support = import ./build-support self pkgs;
  by-name = import ./by-name self pkgs;
  by-scope = import ./by-scope self pkgs;
in
  pkgs.lib.mergeAttrsList [
    by-name
    by-scope
    build-support
    {
      # Pinned packages
      # https://github.com/NixOS/nixpkgs/pull/317546
      my-opencv = pins.opencv-typing.opencv;

      # Overrides and aliases
      dpcppStdenv = self.intel-dpcpp.stdenv;
      ffmpeg-vpl = pkgs.ffmpeg-full.override {
        withVpl = true;
        withMfx = false;
      };
      invokeai = with self.intel-python.pkgs; toPythonApplication invokeai;
      oneapi-dnn = pkgs.oneDNN;
      oneapi-tbb = pkgs.tbb_2021_8;
    }
  ]
