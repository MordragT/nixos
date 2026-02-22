{
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage rec {
  pname = "picklescan";
  version = "0.0.26";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3XiXYVECTwpsYX3LLDHkVEHp6Vcn2xQoJIKzdQ40zMU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [ "picklescan" ];

  meta = {
    description = "Security scanner detecting Python Pickle files performing suspicious actions";
    homepage = "https://github.com/mmaitre314/picklescan";
  };
}
