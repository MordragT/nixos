{
  buildPythonPackage,
  fetchipex,
  autoPatchelfHook,
  intel-ccl,
  intel-mpi,
  intel-dpcpp,
  torch,
  ipex,
}:
buildPythonPackage rec {
  pname = "oneccl_bind_pt";
  version = "2.3.100";
  format = "wheel";

  src = fetchipex {
    package = "${pname}-${version}";
    sha256 = "";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    intel-ccl
    intel-dpcpp.llvm.lib
    intel-mpi
    torch.lib
    ipex.lib
  ];

  dependencies = [
    torch
    ipex
  ];

  pythonImportsCheck = ["oneccl_bind_pt"];
}
