{
  buildPythonPackage,
  python,
  fetchtorch,
  autoPatchelfHook,
  zlib,
  level-zero,
  intel-dpcpp,
}:
buildPythonPackage rec {
  pname = "pytorch_triton_xpu";
  version = "3.5.0";
  format = "wheel";

  src = fetchtorch {
    inherit pname version;
    dist = "whl";
    hash = "";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    zlib
  ];

  postFixup = ''
    substituteInPlace $out/${python.sitePackages}/triton/backends/intel/driver.py \
      --replace-fail 'ze_root = os.getenv("ZE_PATH", default="/usr/local")' \
      'ze_root = os.getenv("ZE_PATH", default="${level-zero}")'

    substituteInPlace $out/${python.sitePackages}/triton/runtime/build.py \
      --replace-fail 'icpx = None' 'icpx = "${intel-dpcpp.clang}/bin/icpx"' \
      --replace-fail 'cxx = os.environ.get("CXX")' 'cxx = icpx'
  '';
}
