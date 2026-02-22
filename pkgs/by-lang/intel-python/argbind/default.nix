{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyyaml,
  docstring-parser,
}:
buildPythonPackage {
  pname = "argbind";
  version = "unstable-2024-05-24";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pseeth";
    repo = "argbind";
    rev = "e3e0b8d2d906e2b99879be7b726353498f29012b";
    hash = "sha256-3Iulc55GnMLqA/0HZJ3BG59xXd7Rg7VMpLWGhNmH8JM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    docstring-parser
  ];

  pythonImportsCheck = [ "argbind" ];
}
