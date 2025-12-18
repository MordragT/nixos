{
  lib,
  fetchPypi,
  buildPythonApplication,
  poetry-core,
  click,
  numpy,
  pydantic,
  pydantic-settings,
  pypdfium2,
}:
buildPythonApplication rec {
  pname = "pdftext";
  version = "0.6.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-q1xd/g8ft43h24N8ytrB6kGwfOGJD+rZc8moTNr1Tew=";
  };

  pythonRelaxDeps = [
    "pypdfium2"
  ];

  build-system = [
    poetry-core
  ];

  dependencies = [
    click
    numpy
    pydantic
    pydantic-settings
    pypdfium2
  ];

  pythonImportsCheck = [
    "pdftext"
  ];

  meta = {
    description = "Extract structured text from pdfs quickly";
    homepage = "https://pypi.org/project/pdftext/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [mordrag];
  };
}
