{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  filelock,
  huggingface-hub,
  opencv4,
  torchvision,
  einops,
  scikit-image,
  timm,
  pythonRelaxDepsHook,
  importlib-metadata,
}:
buildPythonPackage rec {
  pname = "controlnet-aux";
  version = "0.0.7";
  format = "pyproject";

  src = fetchPypi {
    pname = "controlnet_aux";
    inherit version;
    hash = "sha256-23KZMjum04ni/mt9gTGgWica86SsKldHdUSMTQd4vow=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
    pythonRelaxDepsHook
  ];

  dependencies = [
    filelock
    huggingface-hub
    opencv4
    torchvision
    einops
    scikit-image
    timm
    importlib-metadata
  ];

  pythonImportsCheck = ["controlnet_aux"];
  pythonRemoveDeps = ["opencv-python"];

  meta = with lib; {
    description = "Auxillary models for controlnet";
    homepage = "https://pypi.org/project/controlnet-aux/";
    license = licenses.asl20;
    maintainers = with maintainers; [mordrag];
  };
}
