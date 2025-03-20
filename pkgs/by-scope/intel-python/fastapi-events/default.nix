{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
}:
buildPythonPackage rec {
  pname = "fastapi-events";
  version = "0.11.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "melvinkcx";
    repo = "fastapi-events";
    rev = "v${version}";
    hash = "sha256-mmy5druNksOVo7LSlyWS5/eQE/Na1O5dV7UL60YUBNc=";
  };

  doCheck = false;

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = ["fastapi_events"];

  meta = with lib; {
    description = "Asynchronous event dispatching/handling library for FastAPI and Starlette";
    homepage = "https://github.com/melvinkcx/fastapi-events";
    license = licenses.mit;
    maintainers = with maintainers; [mordrag];
  };
}
