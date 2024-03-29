{
  buildPythonPackage,
  fetchurl,
  expecttest,
  hypothesis,
  numpy,
  psutil,
  pytest,
  pyyaml,
  scipy,
  # types-dataclasses,
  typing-extensions,
  pydantic,
  torchWithXpu,
  addOpenGLRunpath,
  autoPatchelfHook,
  level-zero,
  intelPackages,
  zstd,
  ocl-icd,
}:
buildPythonPackage {
  pname = "intel-extension-for-pytorch";
  version = "2.1.10+xpu";
  format = "wheel";

  src = fetchurl {
    url = "https://intel-extension-for-pytorch.s3.amazonaws.com/ipex_stable/xpu/intel_extension_for_pytorch-2.1.10%2Bxpu-cp311-cp311-linux_x86_64.whl";
    sha256 = "sha256-LX3TvEGM5BbPw/nkOhaTq6v+nduTI68y2WFhNw25VSI=";
  };

  nativeBuildInputs = [
    addOpenGLRunpath
    autoPatchelfHook
  ];

  buildInputs = [
    intelPackages.mkl
    intelPackages.runtime
    level-zero
    zstd
    ocl-icd
  ];

  propagatedBuildInputs = [
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
    torchWithXpu
  ];
}
