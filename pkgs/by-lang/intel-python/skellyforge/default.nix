{
  buildPythonPackage,
  fetchPypi,
  pythonRelaxDepsHook,
  flit,
  numpy,
  pyside6,
  pyqtgraph,
  scipy,
  rich,
  pandas,
  matplotlib,
  toml,
}:
buildPythonPackage rec {
  pname = "skellyforge";
  version = "2024.12.1009";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BwMlC5roSq9J7zBIl+JQSHzm0uzBMtTg9K7w6sF5Nx4=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  build-system = [
    flit
  ];

  dependencies = [
    numpy
    pyside6
    pyqtgraph
    scipy
    rich
    pandas
    matplotlib
    toml
  ];

  pythonRemoveDeps = [ ];

  pythonRelaxDeps = [
    "numpy"
    "pyside6"
    "pyqtgraph"
    "scipy"
    "rich"
    "pandas"
    "matplotlib"
  ];

  pythonImportsCheck = [ "skellyforge" ];

  meta = {
    description = "The camera back-end for the `freemocap` project";
    homepage = "https://freemocap.org/";
  };
}
