{
  buildPythonPackage,
  python,
  fetchwheel,
  autoPatchelfHook,
  zlib,
  intelPackages,
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
  pybind11,
}:
buildPythonPackage rec {
  pname = "torch";
  version = "2.1.0a0";
  format = "wheel";

  outputs = ["out" "dev" "lib"];

  src = fetchwheel {
    package = "${pname}-${version}";
    sha256 = "sha256-CjX7U8hFxNMKYDyfDxbHol33Iw9mMfOeBmVnvrqpcp0=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    zlib
    intelPackages.mkl
  ];

  propagatedBuildInputs = [
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
    pybind11
  ];

  postInstall = ''
    mkdir $dev
    cp -r $out/${python.sitePackages}/torch/include $dev/include
    cp -r $out/${python.sitePackages}/torch/share $dev/share


    # Fix up library paths for split outputs
    substituteInPlace \
      $dev/share/cmake/Torch/TorchConfig.cmake \
      --replace \''${TORCH_INSTALL_PREFIX}/lib "$lib/lib"

    substituteInPlace \
      $dev/share/cmake/Caffe2/Caffe2Targets-release.cmake \
      --replace \''${_IMPORT_PREFIX}/lib "$lib/lib"

    mkdir $lib
    mv $out/${python.sitePackages}/torch/lib $lib/lib
    ln -s $lib/lib $out/${python.sitePackages}/torch/lib
  '';
}
