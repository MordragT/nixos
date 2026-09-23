{
  buildPythonPackage,
  fetchPypi,
  setuptools,
  transformers,
  diffusers,
  pyparsing,
  torch,
  notebook,
}:
buildPythonPackage rec {
  pname = "compel";
  version = "2.4.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nZNdNbtNFvoh1LO1Kdi4+dx4TWe0TkL0bNSMndMhrcI=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    diffusers
    pyparsing
    transformers
    torch
    notebook
  ];

  pythonImportsCheck = [ "compel" ];

  meta = {
    description = "A prompting enhancement library for transformers-type text embedding systems";
    homepage = "https://github.com/damian0815/compel";
  };
}
