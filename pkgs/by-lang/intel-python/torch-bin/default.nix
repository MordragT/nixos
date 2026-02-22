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
  pyyaml,
  filelock,
  typing-extensions,
  sympy,
  networkx,
  jinja2,
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
    hash = "sha256-tW1rDWWGPzcFJ+lx2/oEal3SofYcyVBx2ybHZPNuTc4=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
  ];

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
    (pti-gpu.sdk.override { intel-sycl = intel-dpcpp; })
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

  postInstall = ''
    mkdir $dev
    cp -r $out/${python.sitePackages}/torch/include $dev/include
    cp -r $out/${python.sitePackages}/torch/share $dev/share

    # Fix up library paths for split outputs
    substituteInPlace \
      $dev/share/cmake/Torch/TorchConfig.cmake \
      --replace-fail \''${TORCH_INSTALL_PREFIX}/lib "$lib/lib"

    substituteInPlace \
      $dev/share/cmake/Caffe2/Caffe2Targets-release.cmake \
      --replace-fail \''${_IMPORT_PREFIX}/lib "$lib/lib"

    substituteInPlace $out/${python.sitePackages}/torch-${version}+xpu.dist-info/METADATA \
      --replace-fail "Version: ${version}+xpu" "Version: 2.9.1"

    mkdir $lib
    mv $out/${python.sitePackages}/torch/lib $lib/lib
    rm $lib/lib/libOpenCL.so.1

    ln -s $lib/lib $out/${python.sitePackages}/torch/lib
  '';

  pythonImportsCheck = [ "torch" ];
}
