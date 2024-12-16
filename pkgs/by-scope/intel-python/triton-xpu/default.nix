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
  version = "3.2.0";
  format = "wheel";

  src = fetchtorch {
    dist = "whl/nightly";
    abi = "%2Bgite98b6fcb";
    package = "${pname}-${version}";
    sha256 = "sha256-qWP2FxPvon+NWmZ2rICZqJWoDqy1oE9ezCkQuySeazw=";
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
