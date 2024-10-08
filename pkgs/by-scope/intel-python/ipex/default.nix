{
  buildPythonPackage,
  python,
  fetchwheel,
  expecttest,
  hypothesis,
  numpy,
  psutil,
  pytest,
  pyyaml,
  scipy,
  typing-extensions,
  pydantic,
  torch,
  addOpenGLRunpath,
  autoPatchelfHook,
  level-zero,
  intel-mkl,
  intel-dpcpp,
  zstd,
  ocl-icd,
  util-linux,
}:
buildPythonPackage rec {
  pname = "intel_extension_for_pytorch";
  version = "2.1.40";
  format = "wheel";

  outputs = ["out" "dev" "lib"];

  src = fetchwheel {
    abi = "%2Bxpu";
    package = "${pname}-${version}";
    sha256 = "sha256-77FJoi8lhE4IUhd7pa3SwdYyDQboWa6o4NZNgTLJsL4=";
  };

  nativeBuildInputs = [
    addOpenGLRunpath
    autoPatchelfHook
  ];

  buildInputs = [
    intel-mkl
    intel-dpcpp.llvm.lib
    torch.lib
    level-zero
    zstd
    ocl-icd
  ];

  dependencies = [
    expecttest
    hypothesis
    numpy
    psutil
    pytest
    pyyaml
    scipy
    # types-dataclasses
    typing-extensions
    pydantic
    torch
    util-linux
  ];

  postInstall = ''
    mkdir $dev
    cp -r $out/${python.sitePackages}/${pname}/include $dev/include
    cp -r $out/${python.sitePackages}/${pname}/share $dev/share

    substituteInPlace \
      $dev/share/cmake/IPEX/IPEXConfig.cmake \
      --replace-fail \''${IPEX_INSTALL_PREFIX}/lib "$lib/lib"

    mkdir $lib
    mv $out/${python.sitePackages}/${pname}/lib $lib/lib
    ln -s $lib/lib $out/${python.sitePackages}/${pname}/lib
  '';

  meta = {
    description = "A Python package for extending the official PyTorch that can easily obtain performance on Intel platform";
    homepage = "https://github.com/intel/intel-extension-for-pytorch";
    mainProgram = "ipexrun";
  };
}
