{
  buildPythonPackage,
  fetchPypi,
  numpy,
  pystoi,
  torch,
  torchaudio,
}:
buildPythonPackage rec {
  pname = "torch_stoi";
  version = "0.2.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IoIHuNY1SDNsVSCxVvHmsw0649sfs8QZmfAa7gh8X4U=";
  };

  dependencies = [
    numpy
    pystoi
    torch
    torchaudio
  ];

  pythonImportsCheck = ["torch_stoi"];

  meta = {
    description = "STOI loss function in PyTorch ";
    homepage = "https://github.com/mpariente/pytorch_stoi/";
  };
}
