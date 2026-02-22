{
  buildPythonPackage,
  fetchPypi,
  setuptools,
  numpy,
  scipy,
}:
buildPythonPackage rec {
  pname = "pystoi";
  version = "0.4.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HG9Q1vv+5GsAySJFjNvScijZgwyoHOp4j9YA/C995uQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    scipy
  ];

  pythonImportsCheck = [ "pystoi" ];

  meta = {
    description = "Python implementation of the Short Term Objective Intelligibility measure ";
    homepage = "https://github.com/mpariente/pystoi";
  };
}
