{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  jinja2,
  pyparsing,
  pytest,
  pytest-cov,
  pytest-lazy-fixture,
  requests,
  transformers,
}:
buildPythonPackage rec {
  pname = "dynamicprompts";
  version = "0.31.0";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    python = "py3";
    dist = "py3";
    hash = "sha256-oH84wpXsK3eQXOy6iw9Dm7GoSUK/todP9rVUSOLMlQ4=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    jinja2
    pyparsing
  ];

  passthru.optional-dependencies = {
    dev = [
      pytest
      pytest-cov
      pytest-lazy-fixture
    ];
    feelinglucky = [
      requests
    ];
    magicprompt = [
      transformers
    ];
  };

  pythonImportsCheck = [ "dynamicprompts" ];

  meta = with lib; {
    description = "Dynamic prompts templating library for Stable Diffusion";
    homepage = "https://pypi.org/project/dynamicprompts/";
    license = licenses.mit;
    maintainers = with maintainers; [ mordrag ];
  };
}
