{
  buildPythonPackage,
  fetchPypi,
  pythonRelaxDepsHook,
  flit,
  numpy,
  opencv4,
  pydantic,
  pillow,
  psutil,
  setproctitle,
  pyside6,
  matplotlib,
  scipy,
  rich,
  pandas,
  pyqtgraph,
  qtpy,
  toml,
  tqdm,
}:
buildPythonPackage rec {
  pname = "skellycam";
  version = "2025.1.1096";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-631utWOknoXf2QZizF2S2cvIN8fnnx0Zdpm2kkE8XkU=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  build-system = [
    flit
  ];

  dependencies = [
    numpy
    opencv4
    pydantic
    pillow
    psutil
    setproctitle
    pyside6
    matplotlib
    scipy
    rich
    pandas
    pyqtgraph
    qtpy
    toml
    tqdm
  ];

  pythonRemoveDeps = [
    "opencv-contrib-python"
  ];

  pythonRelaxDeps = [
    "numpy"
    "pillow"
    "psutil"
    "setproctitle"
    "pyside6"
    "matplotlib"
    "scipy"
    "rich"
    "pandas"
    "pyqtgraph"
    "qtpy"
    "tqdm"
  ];

  # pythonImportsCheck = ["skellycam"]; # fails

  meta = {
    description = "The camera back-end for the `freemocap` project";
    homepage = "https://freemocap.org/";
  };
}
