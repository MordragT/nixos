{
  buildPythonPackage,
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
  torchWithXpu,
  addOpenGLRunpath,
  autoPatchelfHook,
  level-zero,
  intelPackages,
  zstd,
  ocl-icd,
}:
buildPythonPackage rec {
  pname = "intel_extension_for_pytorch";
  # version = "2.1.20";
  version = "2.1.10";
  format = "wheel";

  src = fetchwheel {
    abi = "xpu";
    package = "${pname}-${version}";
    # sha256 = "sha256-h0KlANwIs62E5nWIb3dXv/f+2Tn0UiVVghUGk4OwDjE=";
    sha256 = "sha256-LX3TvEGM5BbPw/nkOhaTq6v+nduTI68y2WFhNw25VSI=";
  };

  nativeBuildInputs = [
    addOpenGLRunpath
    autoPatchelfHook
  ];

  buildInputs = [
    intelPackages.mkl
    intelPackages.runtime
    torchWithXpu.lib
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
