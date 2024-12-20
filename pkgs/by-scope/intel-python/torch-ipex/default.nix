{
  buildPythonPackage,
  python,
  fetchipex,
  autoPatchelfHook,
  zlib,
  intel-mkl,
  intel-dpcpp,
  pti-gpu,
  zstd-native,
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
  version = "2.5.1";
  format = "wheel";

  outputs = ["out" "dev" "lib"];

  src = fetchipex {
    inherit pname version;
    suffix = "%2Bcxx11.abi";
    hash = "sha256-wKgSrOlE0P77m/grmC2GvQyQ/S1N7WEHDr51xf9HXjo=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    zlib
    intel-mkl
    (pti-gpu.sdk.override {intel-sycl = intel-dpcpp;})
    zstd-native.dev
  ];

  dependencies = [
    packaging
    astunparse
    cffi
    click
    numpy
    pyyaml

    # From install_requires:
    fsspec
    filelock
    typing-extensions
    sympy
    networkx
    jinja2

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

    mkdir $lib
    mv $out/${python.sitePackages}/torch/lib $lib/lib
    ln -s $lib/lib $out/${python.sitePackages}/torch/lib
  '';

  pythonImportsCheck = ["torch"];
}
