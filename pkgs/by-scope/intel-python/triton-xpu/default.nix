{
  buildPythonPackage,
  fetchwheel,
  autoPatchelfHook,
  zlib,
}:
buildPythonPackage rec {
  pname = "pytorch_triton_xpu";
  version = "3.2.0";
  format = "wheel";

  src = fetchwheel {
    base = "https://download.pytorch.org/";
    dist = "whl/nightly";
    abi = "%2Bgite98b6fcb";
    package = "${pname}-${version}";
    sha256 = "sha256-N2+42RaRWSXKz5iGmHfoMu7PgqkeOj2e709lpusJofA=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    zlib
  ];
}
