{
  buildPythonPackage,
  fetchtorch,
  numpy,
  torch,
  torchaudio,
}:
let
  pname = "torchcodec";
  version = "0.16.0";
in
buildPythonPackage {
  inherit pname version;
  format = "wheel";

  src = fetchtorch {
    inherit pname version;
    suffix = "%2Bcpu";
    platform = "manylinux_2_27_x86_64.manylinux_2_28_x86_64";
    hash = "sha256-XIYxpwf4vw5o17yfawO1zEMXMJG8f+DgYF25W+UG7xU=";
  };

  buildInputs = [
    torch.lib
  ];

  dependencies = [
    numpy
    torch
    torchaudio
  ];

  pythonImportsCheck = [ "torchcodec" ];
}
