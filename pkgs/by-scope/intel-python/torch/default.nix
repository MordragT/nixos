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
  version = "2.1.0.post3";
  format = "wheel";

  outputs = ["out" "dev" "lib"];

  src = fetchwheel {
    package = "${pname}-${version}";
    sha256 = "sha256-uOi0ccNP3AH4xh7pp5+6p9joFZuegkAIp1x9A+mbQ94=";
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


    substituteInPlace $out/${python.sitePackages}/${pname}/utils/cpp_extension.py \
      --replace-fail "from pkg_resources import packaging" "import packaging"

    mkdir $lib
    mv $out/${python.sitePackages}/torch/lib $lib/lib
    ln -s $lib/lib $out/${python.sitePackages}/torch/lib

    # # remove version suffix for dependent packages
    # substituteInPlace $out/${python.sitePackages}/torch/version.py \
    #   --replace-fail "__version__ = '${version}+cxx11.abi'" "__version__ = '${version}'"

    # mv $out/${python.sitePackages}/torch-${version}+cxx11.abi.dist-info $out/${python.sitePackages}/torch-${version}.dist-info

    # substituteInPlace $out/${python.sitePackages}/torch-${version}.dist-info/METADATA \
    #   --replace-fail "Version: ${version}+cxx11.abi" "Version: 2.1.0"
  '';
}
