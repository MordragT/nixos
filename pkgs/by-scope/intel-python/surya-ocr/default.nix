{
  lib,
  buildPythonApplication,
  fetchPypi,
  poetry-core,
  click,
  einops,
  filetype,
  opencv-python-headless,
  pillow,
  platformdirs,
  pydantic,
  pydantic-settings,
  pypdfium2,
  python-dotenv,
  torch,
  transformers,
}:
buildPythonApplication rec {
  pname = "surya-ocr";
  version = "0.17.0";
  pyproject = true;

  src = fetchPypi {
    pname = "surya_ocr";
    inherit version;
    hash = "sha256-MRDsmivg1ClpaM7QLuTTOUHzTBRaLWrFCPdRIgFO0XA=";
  };

  pythonRelaxDeps = [
    "opencv-python-headless"
    "pillow"
    "pypdfium2"
  ];

  pythonRemoveDeps = [
    "pre-commit"
  ];

  build-system = [
    poetry-core
  ];

  dependencies = [
    click
    einops
    filetype
    opencv-python-headless
    pillow
    platformdirs
    pydantic
    pydantic-settings
    pypdfium2
    python-dotenv
    torch
    transformers
  ];

  pythonImportsCheck = [
    "surya"
  ];

  meta = {
    description = "OCR, layout, reading order, and table recognition in 90+ languages";
    homepage = "https://pypi.org/project/surya-ocr/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [mordrag];
  };
}
