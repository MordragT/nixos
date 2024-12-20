{
  buildPythonPackage,
  fetchipex,
  autoPatchelfHook,
  numpy,
  pillow,
  torch-ipex,
  scipy,
  libpng,
  libjpeg,
  libjpeg8,
}:
buildPythonPackage rec {
  pname = "torchvision";
  version = "0.20.1";
  format = "wheel";

  src = fetchipex {
    inherit pname version;
    suffix = "%2Bcxx11.abi";
    hash = "sha256-+CAMBOBomNc0nmT+jGwOhXfhAKtl0JEMAnFP2MC+WNc=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    torch-ipex.lib
    libpng
    libjpeg
    libjpeg8
  ];

  dependencies = [
    numpy
    pillow
    torch-ipex
    scipy
  ];

  pythonImportsCheck = ["torchvision"];
}
