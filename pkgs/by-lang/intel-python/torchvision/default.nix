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
let
  pname = "torchvision";
  version = "0.29.0";
in
buildPythonPackage {
  inherit pname version;
  format = "wheel";

  src = fetchtorch {
    inherit pname version;
    suffix = "%2Bxpu";
    hash = "sha256-tomSJct+QdsJSzLXyN+KFbOeWnU4eXad6afiYuRTC3Y=";
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

  pythonImportsCheck = [ "torchvision" ];
}
