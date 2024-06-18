self: pkgs: let
  pins = import ./pins.nix {inherit (pkgs) system;};
  by-name = import ./by-name self pkgs;
  by-prefix = import ./by-prefix self pkgs;
  by-scope = import ./by-scope self pkgs;
in
  pkgs.lib.mergeAttrsList [
    by-name
    by-prefix
    by-scope
    {
      # Pinned packages
      # onevpl-intel-gpu = pins.vpl.onevpl-intel-gpu;
      # https://github.com/NixOS/nixpkgs/pull/317546
      my-opencv = pins.opencv-typing.opencv;

      # Overrides
      ffmpeg-vpl = pkgs.ffmpeg-full.override {
        withVpl = true;
        withMfx = false;
      };
      # llama-cpp = pkgs.llama-cpp.override {
      #   openclSupport = true;
      #   blasSupport = false;
      # };
      gamescope = pkgs.gamescope_git;
    }
  ]
