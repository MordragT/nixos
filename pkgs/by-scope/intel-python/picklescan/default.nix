{
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage rec {
  pname = "picklescan";
  version = "0.0.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5HFpf+VPVIL/IvGDpOP9q0pdleNshiSW3QffX8qJVAk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = ["picklescan"];

  meta = {
    description = "Security scanner detecting Python Pickle files performing suspicious actions";
    homepage = "https://github.com/mmaitre314/picklescan";
  };
}
