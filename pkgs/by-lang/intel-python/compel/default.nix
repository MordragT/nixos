{
  buildPythonPackage,
  fetchPypi,
  setuptools,
  transformers,
  diffusers,
  pyparsing,
  torch,
}:
buildPythonPackage rec {
  pname = "compel";
  version = "2.1.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-miAYGXIxk6Cz71wJChUOZLTvXgFxUmLc5yPr0ysi33w=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    diffusers
    pyparsing
    transformers
    torch
  ];

  pythonImportsCheck = [ "compel" ];

  meta = {
    description = "A prompting enhancement library for transformers-type text embedding systems";
    homepage = "https://github.com/damian0815/compel";
  };
}
