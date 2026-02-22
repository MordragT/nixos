{
  buildPythonPackage,
  fetchPypi,
  pythonRelaxDepsHook,
  flit,
  numpy,
  rich,
  pyside6,
  opencv4,
  pandas,
  matplotlib,
}:
buildPythonPackage rec {
  pname = "skelly_viewer";
  version = "2024.12.1026";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-g8gshACa6IkX1G6+y8KqvY390oB6JdLCT+TeOlkROXE=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  build-system = [
    flit
  ];

  dependencies = [
    numpy
    rich
    pyside6
    opencv4
    pandas
    matplotlib
  ];

  pythonRemoveDeps = [
    "opencv-contrib-python"
    "pytest"
  ];

  pythonRelaxDeps = [
    "numpy"
    "rich"
    "pyside6"
    "pandas"
    "matplotlib"
  ];

  # pythonImportsCheck = ["skelly_viewer"]; # fails

  meta = {
    description = "The camera back-end for the `freemocap` project";
    homepage = "https://freemocap.org/";
  };
}
