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
  version = "2.0.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Lp3mS26l+d9Z+Prn662aV9HzadzJU8hkWICkm7GcLHw=";
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

  pythonImportsCheck = ["compel"];

  meta = {
    description = "A prompting enhancement library for transformers-type text embedding systems";
    homepage = "https://github.com/damian0815/compel";
  };
}
