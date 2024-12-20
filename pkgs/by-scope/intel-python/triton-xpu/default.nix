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
  version = "3.1.0";
  format = "wheel";

  src = fetchtorch {
    inherit pname version;
    dist = "whl/nightly";
    suffix = "%2B91b14bf559";
    hash = "sha256-+L6UiQjAUhoxSVpxss48o7H00VPJth+aa0TJzuGRoAk=";
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
