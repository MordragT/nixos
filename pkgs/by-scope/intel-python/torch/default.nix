{
  buildPythonPackage,
  python,
  fetchtorch,
  autoPatchelfHook,
  autoAddDriverRunpath,
  zlib,
  intel-dpcpp,
  intel-mkl,
  intel-ccl,
  pti-gpu,
  ocl-icd,
  packaging,
  astunparse,
  cffi,
  click,
  pyyaml,
  fsspec,
  filelock,
  typing-extensions,
  sympy,
  networkx,
  jinja2,
  pillow,
  six,
  tensorboard,
  protobuf,
  numpy,
  requests,
  setuptools,
}:
buildPythonPackage rec {
  pname = "torch";
  version = "2.9.1";
  format = "wheel";

  src = fetchtorch {
    inherit pname version;
    suffix = "%2Bxpu";
    hash = "sha256-jHkVAGdS2r5ddSYU2z3FTOLoFja65hu5bMFC58yb3R0=";
  };

  dontStrip = true;

  nativeBuildInputs = [
    autoPatchelfHook
    autoAddDriverRunpath
  ];

  buildInputs = [
    zlib
    intel-mkl
    intel-ccl
    intel-dpcpp.llvm.lib
    (pti-gpu.sdk.override {intel-sycl = intel-dpcpp;})
    ocl-icd
  ];

  dependencies = [
    filelock
    jinja2
    networkx
    numpy
    pyyaml
    requests
    setuptools
    sympy
    typing-extensions
  ];

  # postInstall = ''
  #   mkdir $dev
  #   cp -r $out/${python.sitePackages}/torch/include $dev/include
  #   cp -r $out/${python.sitePackages}/torch/share $dev/share

  #   # Fix up library paths for split outputs
  #   substituteInPlace \
  #     $dev/share/cmake/Torch/TorchConfig.cmake \
  #     --replace-fail \''${TORCH_INSTALL_PREFIX}/lib "$lib/lib"

  #   substituteInPlace \
  #     $dev/share/cmake/Caffe2/Caffe2Targets-release.cmake \
  #     --replace-fail \''${_IMPORT_PREFIX}/lib "$lib/lib"

  #   substituteInPlace $out/${python.sitePackages}/torch-${version}+xpu.dist-info/METADATA \
  #     --replace-fail "Version: ${version}+xpu" "Version: 2.9.1"

  #   mkdir $lib
  #   mv $out/${python.sitePackages}/torch/lib $lib/lib
  #   rm $lib/lib/libOpenCL.so.1

  #   ln -s $lib/lib $out/${python.sitePackages}/torch/lib
  # '';

  pythonImportsCheck = ["torch"];
}
