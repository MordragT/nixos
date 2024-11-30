{
  buildPythonPackage,
  fetchwheel,
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
  version = "0.18.1";
  format = "wheel";

  src = fetchwheel {
    package = "${pname}-${version}";
    sha256 = "sha256-8ik1UtiFCl1lM61AcSGnrWrHODcl+lhcS3mtSyUqmGY=";
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
