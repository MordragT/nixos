{
  buildPythonPackage,
  fetchwheel,
  autoPatchelfHook,
  intel-ccl,
  intel-mpi,
  intel-dpcpp,
  torch,
  ipex,
}:
buildPythonPackage rec {
  pname = "oneccl_bind_pt";
  version = "2.1.300";
  format = "wheel";

  src = fetchwheel {
    abi = "%2Bxpu";
    package = "${pname}-${version}";
    sha256 = "sha256-UAOOwlBgIB19XuXjAdSZ1jhYtISPaEhLybbULLeXK/0=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    intel-ccl
    intel-dpcpp.runtime
    intel-mpi
    torch.lib
    ipex.lib
  ];

  dependencies = [
    torch
    ipex
  ];
}
