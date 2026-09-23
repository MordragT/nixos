{
  lib,
  buildPythonPackage,
  fetchtorch,
  autoPatchelfHook,
  zlib,
  pyelftools,
}:
buildPythonPackage rec {
  pname = "triton_xpu";
  version = "3.6.0";
  format = "wheel";

  src = fetchtorch {
    inherit pname version;
    dist = "whl";
    platform = "manylinux_2_27_x86_64.manylinux_2_28_x86_64";
    hash = "sha256-b2i0GTEJkACA6I8I7jXV/ifboM91BOu+7HS/6sBmrJU=";
  };

  dependencies = [
    pyelftools
  ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    zlib
  ];

  # postFixup = ''
  #   substituteInPlace $out/${python.sitePackages}/triton/backends/intel/driver.py \
  #     --replace-fail 'ze_root = os.getenv("ZE_PATH", default="/usr/local")' \
  #     'ze_root = os.getenv("ZE_PATH", default="${level-zero}")'

  #   substituteInPlace $out/${python.sitePackages}/triton/runtime/build.py \
  #     --replace-fail 'icpx = shutil.which("icpx")' 'icpx = "${intel-dpcpp.clang}/bin/icpx"'
  # '';

  meta = {
    description = "Triton compiler with Intel XPU backend";
    homepage = "https://github.com/intel/intel-xpu-backend-for-triton";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
