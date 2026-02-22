{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  fire,
}:
buildPythonPackage {
  pname = "randomname";
  version = "0.2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "beasteers";
    repo = "randomname";
    rev = "14b419a536ce1c6a9a2220ac156a399c05720762";
    hash = "sha256-h1K9CaO95g5CMup6vRjLbQSU7TRmdeWOjme2oTc/2Ic=";
  };

  build-system = [ setuptools ];

  dependencies = [
    fire
  ];

  pythonImportsCheck = [ "randomname" ];
}
