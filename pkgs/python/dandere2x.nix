{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  numpy,
  imageio,
  pillow,
  pyqt6,
  dataclasses,
  pyyaml,
  psutil,
  wget,
  colorlog,
  future-annotations,
}: let
  src = fetchFromGitHub {
    owner = "akai-katto";
    repo = "dandere2x";
    rev = "b1b645c3eeafe1808de297b27f544e208436f8a8";
    sha256 = "CtB7rbLXymOtepsiUHl3M+H2Sjvt9SDkPq8Cp5rCY5I=";
  };
in
  buildPythonApplication {
    name = "dandere2x";
    src = "${src}/src";

    propagatedBuildInputs = [
      numpy
      imageio
      pillow
      pyqt6
      dataclasses
      pyyaml
      psutil
      wget
      colorlog
      future-annotations
    ];

    preBuild = ''
      substituteInPlace requirements.txt \
        --replace "imageio==2.9.0" "imageio==2.19.3" \
        --replace "pyyaml==5.4" "pyyaml==6.0" \
        --replace "colorlog==4.1.0" "colorlog==6.6.0"

      cat >setup.py <<'EOF'
      from setuptools import setup

      with open('requirements.txt') as f:
          install_requires = f.read().splitlines()

      setup(
        name='dandere2x',
        packages=['dandere2x', 'gui', 'config_files'],
        version='3.6.0',
        #author='...',
        #description='...',
        install_requires=install_requires,
        entry_points={
          # example: file some_module.py -> function main
          'console_scripts': ['dandere2x=main:main']
        },
      )
    '';

    meta = with lib; {
      maintainers = with maintainers; [mordrag];
      platforms = platforms.linux;
      broken = true;
    };
  }
