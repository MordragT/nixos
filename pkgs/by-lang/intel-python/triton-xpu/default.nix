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
    platform = "manylinux_2_27_x86_64.manylinux_2_28_x86_64";
    hash = "sha256-DSTBcWCI8nZNDSTGQidzIZW2pCcGw8X8ie60kEv6CBg=";
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
      --replace-fail 'icpx = shutil.which("icpx")' 'icpx = "${intel-dpcpp.clang}/bin/icpx"'
  '';
}
