{
  buildPythonPackage,
  python,
  fetchwheel,
  autoPatchelfHook,
  zlib,
  intel-mkl,
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
  version = "2.3.1";
  format = "wheel";

  outputs = ["out" "dev" "lib"];

  src = fetchwheel {
    package = "${pname}-${version}";
    sha256 = "sha256-yd5H0liod0FIRyoB89K49G2i9qSvPi+Ko4Md/6L9Ozo=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    zlib
    intel-mkl
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
}
