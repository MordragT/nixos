{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
}:
buildPythonPackage rec {
  pname = "fastapi-events";
  version = "0.12.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "melvinkcx";
    repo = "fastapi-events";
    rev = "v${version}";
    hash = "sha256-YOaUWv8luypHzKs7kDLl0Z9f34HPmhMoExagkYiwdl8=";
  };

  doCheck = false;

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "fastapi_events" ];

  meta = with lib; {
    description = "Asynchronous event dispatching/handling library for FastAPI and Starlette";
    homepage = "https://github.com/melvinkcx/fastapi-events";
    license = licenses.mit;
    maintainers = with maintainers; [ mordrag ];
  };
}
