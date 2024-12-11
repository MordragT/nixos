{
  buildPythonPackage,
  fetchwheel,
  autoPatchelfHook,
  zlib,
}:
buildPythonPackage rec {
  pname = "pytorch_triton_xpu";
  version = "3.0.0";
  format = "wheel";

  src = fetchwheel {
    base = "https://download.pytorch.org/";
    dist = "whl/nightly";
    abi = "%2B1b2f15840e";
    package = "${pname}-${version}";
    sha256 = "sha256-hwFG6wzEiaSam7mAh6xl30XF+TENGOadY5mgSIEY7D4=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    zlib
  ];
}
