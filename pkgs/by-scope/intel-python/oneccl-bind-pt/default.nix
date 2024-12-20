{
  buildPythonPackage,
  fetchipex,
  autoPatchelfHook,
  intel-ccl,
  intel-mpi,
  intel-sycl,
  torch,
  ipex,
}:
buildPythonPackage rec {
  pname = "oneccl_bind_pt";
  version = "2.5.0";
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
    intel-sycl.llvm.lib
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
