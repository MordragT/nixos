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
    package = "${pname}-${version}";
    abi = "%2Bcxx11.abi";
    sha256 = "sha256-PPn4WKrqEX1BbAwCjXxwyvljsSe9zshdu4BYRV4pwqo=";
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
