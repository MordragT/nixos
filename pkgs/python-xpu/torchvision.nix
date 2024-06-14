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
  version = "0.16.0.post2";
  format = "wheel";

  src = fetchwheel {
    package = "${pname}-${version}";
    sha256 = "sha256-K8Qoq72hfAWKN12T4tZsp5BB5N24ohvb72d41pY04to=";
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

  propagatedBuildInputs = [
    numpy
    pillow
    torch
    scipy
  ];
}
