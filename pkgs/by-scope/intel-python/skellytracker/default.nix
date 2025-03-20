{
  buildPythonPackage,
  fetchPypi,
  pythonRelaxDepsHook,
  flit,
  opencv4,
  pydantic,
  numpy,
  tqdm,
  mediapipe,
}:
buildPythonPackage rec {
  pname = "skellytracker";
  version = "2024.9.1019";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-hXs43FQe76iM+8+F6drN8Auv5ViFyT1oGd7gFdvDrDw=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  build-system = [
    flit
  ];

  dependencies = [
    opencv4
    pydantic
    numpy
    tqdm
  ];

  optional-dependencies = {
    # dev = [
    #   black
    #   bumpver
    #   isort
    #   pip-tools
    #   pytest
    #   ruff
    # ];
    mediapipe = [mediapipe];
    # yolo = [ultralytics];
  };

  pythonRemoveDeps = [
    "opencv-contrib-python="
  ];

  pythonRelaxDeps = [
    "numpy"
  ];

  # pythonImportsCheck = ["skellytracker"]; # fails

  meta = {
    description = " A pose estimation and object detection/tracking backend for freemocap. ";
    homepage = "https://freemocap.org/";
  };
}
