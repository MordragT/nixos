{
  buildPythonPackage,
  fetchwheel,
  autoPatchelfHook,
  numpy,
  pillow,
  torchWithXpu,
  scipy,
}:
buildPythonPackage rec {
  pname = "torchvision";
  version = "0.16.0a0";
  format = "wheel";

  src = fetchwheel {
    package = "${pname}-${version}";
    sha256 = "sha256-gyHFDlIvXer9PMQz5i9WDpt4rUOJ7vhDBJiEs1IwEp4=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    torchWithXpu.lib
  ];

  propagatedBuildInputs = [
    numpy
    pillow
    torchWithXpu
    scipy
  ];
}
