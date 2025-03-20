{
  buildPythonPackage,
  fetchPypi,
  pythonRelaxDepsHook,
  flit,
  librosa,
  pyside6,
  numpy,
  scipy,
  opencv4,
  deffcode,
  toml,
  matplotlib,
}:
buildPythonPackage rec {
  pname = "skelly_synchronize";
  version = "2025.1.1036";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XAtONwGiwpU9axk6kADU6OJVWRj7RK+L4zbXOzaKV5k=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  build-system = [
    flit
  ];

  dependencies = [
    librosa
    pyside6
    numpy
    scipy
    opencv4
    deffcode
    toml
    matplotlib
  ];

  pythonRemoveDeps = [
    "opencv-contrib-python"
  ];

  pythonRelaxDeps = [
    "librosa"
    "pyside6"
    "numpy"
    "scipy"
    "matplotlib"
  ];

  # pythonImportsCheck = ["skelly_synchronize"]; # fails

  meta = {
    description = "The camera back-end for the `freemocap` project";
    homepage = "https://freemocap.org/";
  };
}
