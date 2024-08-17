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
  version = "0.16.0.post3";
  format = "wheel";

  src = fetchwheel {
    package = "${pname}-${version}";
    sha256 = "sha256-7i2b4fSXGNEY9f1W6TlXtdQ/ZLjqbZsjgnL0IQJ06O8=";
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
}
