{
  buildPythonPackage,
  python,
  fetchipex,
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
  addDriverRunpath,
  autoPatchelfHook,
  level-zero,
  intel-mkl,
  intel-dpcpp,
  zstd,
  ocl-icd,
  util-linux,
  ruamel-yaml,
}:
buildPythonPackage rec {
  pname = "intel_extension_for_pytorch";
  version = "2.8.10";
  format = "wheel";

  outputs = ["out" "dev" "lib"];

  src = fetchipex {
    inherit pname version;
    suffix = "%2Bxpu";
    hash = "";
  };

  nativeBuildInputs = [
    addDriverRunpath
    autoPatchelfHook
  ];

  buildInputs = [
    intel-mkl
    intel-dpcpp.llvm.lib
    torch.lib
    level-zero
    zstd.dev
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
    ruamel-yaml
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

  pythonImportsCheck = ["intel_extension_for_pytorch"];

  meta = {
    description = "A Python package for extending the official PyTorch that can easily obtain performance on Intel platform";
    homepage = "https://github.com/intel/intel-extension-for-pytorch";
    mainProgram = "ipexrun";
  };
}
