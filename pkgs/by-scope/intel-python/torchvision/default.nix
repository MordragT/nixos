{
  buildPythonPackage,
  fetchtorch,
  autoPatchelfHook,
  numpy,
  pillow,
  torch,
  scipy,
  libpng,
  libjpeg,
  libjpeg8,
}:
buildPythonPackage rec {
  pname = "torchvision";
  version = "0.24.1";
  format = "wheel";

  src = fetchtorch {
    inherit pname version;
    suffix = "%2Bxpu";
    platform = "manylinux_2_28_x86_64";
    hash = "";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    torch.lib
    libpng
    libjpeg
    libjpeg8
  ];

  dependencies = [
    numpy
    pillow
    torch
    scipy
  ];

  pythonImportsCheck = ["torchvision"];
}
