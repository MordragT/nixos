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
  version = "2.6.0";
  format = "wheel";

  src = fetchipex {
    inherit pname version;
    suffix = "%2Bxpu";
    hash = "sha256-Y7kb0OeDO7bbZ4kZD3/GlowZcRsJYlv80WY0w5wBr9U=";
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

  pythonImportsCheck = ["oneccl_bindings_for_pytorch"];
}
