{
  lib,
  buildPythonPackage,
  python,
  fetchtorch,
  autoPatchelfHook,
  autoAddDriverRunpath,
  zlib,
  intel-oneapi,
  filelock,
  fsspec,
  typing-extensions,
  sympy,
  networkx,
  jinja2,
  numpy,
  setuptools,
}:
let
  pname = "torch";
  version = "2.14.0";
in
buildPythonPackage {
  inherit pname version;
  format = "wheel";

  src = fetchtorch {
    inherit pname version;
    suffix = "%2Bxpu";
    hash = "sha256-WvZeKJZY9wmnqvJqwTw/qRQ3NHvzkfTZu9W6jELSJ64=";
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
    intel-oneapi
  ];

  dependencies = [
    filelock
    fsspec
    jinja2
    networkx
    numpy
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
      --replace-fail "Version: ${version}+xpu" "Version: ${version}"

    # The XPU wheel names ~20 Intel runtime wheels that nixpkgs provides under
    # different pip-visible names, so anything that resolves torch's declared
    # requirements reports every one of them as missing. dontCheckRuntimeDeps
    # above only covers this derivation; downstream builds (xformers builds a
    # wheel with `pypa build --no-isolation`, which validates build deps) read
    # the installed METADATA and fail. Strip those entries, exactly as the
    # CUDA wheel does for its nvidia-* requirements. Nix still supplies the
    # libraries through propagatedBuildInputs.
    for metadata in "$out/${python.sitePackages}"/torch-*.dist-info/METADATA; do
    if [[ -f "$metadata" ]]; then
        sed -i -E '/^Requires-Dist: (dpcpp-|impi-|intel-|mkl|oneccl|onemkl-|tbb|tcmlib|triton|umf)/d' "$metadata"
    fi
    done

    mkdir $lib
    mv $out/${python.sitePackages}/torch/lib $lib/lib
    ln -s $lib/lib $out/${python.sitePackages}/torch/lib
  '';

  pythonImportsCheck = [ "torch" ];

  dontCheckRuntimeDeps = true;

  meta = {
    description = "PyTorch with Intel XPU ${version} (pre-built wheel, oneAPI/SYCL)";
    homepage = "https://pytorch.org";
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
  };
}
