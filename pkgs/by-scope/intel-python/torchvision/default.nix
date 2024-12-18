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
  version = "0.22.0.dev20241213";
  format = "wheel";

  src = fetchtorch {
    package = "${pname}-${version}";
    sha256 = "sha256-kcIYUm7KDGxdkjdjf/yhR9cX150BUQfrlt/hZxrVl2I=";
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
