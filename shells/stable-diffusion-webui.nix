{pkgs}: let
  # webui = pkgs.fetchFromGitHub {
  #   owner = "openvinotoolkit";
  #   repo = "stable-diffusion-webui";
  #   rev = "44006297e03a07f28505d54d6ba5fd55e0c1292d";
  #   sha256 = "nJirxq7xHFPdCDbfVhTd2ffaAwlIY+347zeRU9Ka4ZQ=";
  # };
  # stable-diffusion = pkgs.writeShellScriptBin "stable-diffusion" ''
  #   python3 ${webui}/launch.py
  # '';
  pythonPackages = pkgs.python3Packages;
in
  pkgs.mkShell rec {
    name = "stable-diffusion-webui-shell";

    venvDir = "./.venv";

    buildInputs = with pkgs; [
      pythonPackages.python
      pythonPackages.venvShellHook
      pythonPackages.openvino

      #stable-diffusion

      git
      stdenv.cc.cc.lib
      stdenv.cc
      ncurses5
      binutils
      gitRepo
      gnupg
      autoconf
      curl
      procps
      gnumake
      util-linux
      m4
      gperf
      unzip
      libGLU
      libGL
      glib
    ];

    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;

    # Run this command, only after creating the virtual environment
    postVenvCreation = ''
      unset SOURCE_DATE_EPOCH
      pip install -r requirements.txt
    '';

    # Now we can execute any commands within the virtual environment.
    # This is optional and can be left out to run pip manually.
    postShellHook = ''
      # allow pip to install wheels
      unset SOURCE_DATE_EPOCH
    '';

    meta = with pkgs.lib; {
      license = licenses.agpl3;
      maintainers = with maintainers; [mordrag];
      description = "Stable Diffusion web UI";
      platforms = platforms.linux;
    };
  }
