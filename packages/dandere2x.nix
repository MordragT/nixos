{ pkgs }:
let
  src = pkgs.fetchFromGitHub {
    owner = "akai-katto";
    repo = "dandere2x";
    rev = "1af3d27df432d0123d698da452d14f848fe923b7";
    sha256 = "GdZtpc4EtbUfvIskHE7Xh8LdUk0ttpJWycGr7KbMFDM=";
  };
in

with pkgs.python310Packages;

buildPythonPackage {
  name = "dandere2x";
  src = "${src}/src";

  nativeBuildInputs = with pkgs; [ sd ];

  propagatedBuildInputs =
    [
      numpy
      opencv4
      imageio
      pillow
      pyqt5
      dataclasses-serialization
      pyyaml
      psutil
      wget
      colorlog
    ];

  preBuild = ''
    sd ==1.19.3 ==1.21.6 requirements.txt
    sd ==2.9.0 ==2.19.2 requirements.txt
    sd ==5.15.2 ==5.15.4 requirements.txt
    sd ==5.4 ==6.0 requirements.txt
    sd ==4.1.0 ==6.6.0 requirements.txt
    sd future-annotations ' ' requirements.txt

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
}

# opencv-contrib-python
# numpy==1.19.3
# imageio==2.9.0
# Pillow
# PyQt5==5.15.2
# dataclasses==0.6
# pyyaml==5.4
# psutil
# wget==3.2
# colorlog==4.1.0
# future-annotations
