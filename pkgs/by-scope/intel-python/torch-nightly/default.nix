{
  buildPythonPackage,
  python,
  fetchtorch,
  autoPatchelfHook,
  autoAddDriverRunpath,
  zlib,
  intel-mkl,
  intel-sycl,
  pti-gpu,
  ocl-icd,
  packaging,
  astunparse,
  cffi,
  click,
  numpy,
  pyyaml,
  fsspec,
  filelock,
  typing-extensions,
  sympy,
  networkx,
  jinja2,
  pillow,
  six,
  future,
  tensorboard,
  protobuf,
  # pybind11,
}:
buildPythonPackage rec {
  pname = "torch";
  version = "2.6.0.dev20241220";
  format = "wheel";

  outputs = ["out" "dev" "lib"];

  src = fetchtorch {
    inherit pname version;
    sha256 = "sha256-cf/1FVNaD+oi6E1jEpXx7yc8Y1Y8HFMg67ZGZS6gNfw=";
  };

  dontStrip = true;

  nativeBuildInputs = [
    autoPatchelfHook
    autoAddDriverRunpath
  ];

  buildInputs = [
    zlib
    intel-mkl
    intel-sycl.llvm.lib
    pti-gpu.sdk
    ocl-icd
  ];

  dependencies = [
    packaging
    astunparse
    cffi
    click
    numpy
    pyyaml

    # From install_requires:
    filelock
    typing-extensions
    sympy
    networkx
    jinja2
    fsspec

    # the following are required for tensorboard support
    pillow
    six
    future
    tensorboard
    protobuf

    # torch/csrc requires `pybind11` at runtime
    # pybind11
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
      --replace-fail "Version: ${version}+xpu" "Version: 2.6.0"

    mkdir $lib
    mv $out/${python.sitePackages}/torch/lib $lib/lib
    rm $lib/lib/libOpenCL.so.1

    ln -s $lib/lib $out/${python.sitePackages}/torch/lib
  '';

  pythonImportsCheck = ["torch"];
}
