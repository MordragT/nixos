{
  lib,
  fetchFromGitHub,
  python3Packages,
  ...
}:
python3Packages.buildPythonPackage {
  pname = "mtkclient";
  version = "unstable-2024-10-28";

  src = fetchFromGitHub {
    owner = "bkerler";
    repo = "mtkclient";
    rev = "77255c45bc1b6f5c789354e15738ccf7057e8cd1";
    sha256 = "sha256-6zVrke4PXt1EmyG9vDNoo6sMjuIarmcMq4j4MuMMER8=";
  };

  pyproject = true;
  build-system = [python3Packages.hatchling];
  dependencies = with python3Packages; [
    capstone
    colorama
    flake8
    fusepy
    keystone-engine
    mock
    pycryptodome
    pycryptodomex
    pyserial
    pyside6
    pyusb
    setuptools
    shiboken6
    unicorn
  ];

  meta = with lib; {
    mainProgram = "mtk";
    maintainers = with lib.maintainers; [mordrag];
    description = "MTK reverse engineering and flash tool";
    homepage = "https://github.com/bkerler/mtkclient";
    license = with licenses; [gpl3Only];
  };
}
