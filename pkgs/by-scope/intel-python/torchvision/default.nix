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
    hash = "sha256-2cWe5a49BWDwJAHI39gFTVCBOo27XTOod33n0C9vy3s=";
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
