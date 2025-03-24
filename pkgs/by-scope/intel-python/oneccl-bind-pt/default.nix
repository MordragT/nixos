{
  buildPythonPackage,
  fetchipex,
  autoPatchelfHook,
  intel-ccl,
  intel-mpi,
  intel-sycl,
  torch-ipex,
  ipex,
}:
buildPythonPackage rec {
  pname = "oneccl_bind_pt";
  version = "2.6.0";
  format = "wheel";

  src = fetchipex {
    inherit pname version;
    suffix = "%2Bxpu";
    hash = "";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    intel-ccl
    intel-sycl.llvm.lib
    intel-mpi
    torch-ipex.lib
    ipex.lib
  ];

  dependencies = [
    torch-ipex
    ipex
  ];

  pythonImportsCheck = ["oneccl_bind_pt"];
}
