{
  buildPythonPackage,
  fetchPypi,
  pythonRelaxDepsHook,
  setuptools,
  opencv4,
  numba,
  pandas,
  numpy,
  scipy,
  toml,
  tqdm,
}:
buildPythonPackage rec {
  pname = "aniposelib";
  version = "0.7.0";
  format = "wheel";

  src = fetchPypi {
    inherit pname version format;
    sha256 = "sha256-+/ocFPQOTv6K2xwckolRF2CHRafJ98kef+AiTCKgKCE=";
    python = "py3";
    dist = "py3";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    opencv4
    numba
    pandas
    numpy
    scipy
    toml
    tqdm
  ];

  pythonRemoveDeps = [
    "opencv-contrib-python"
  ];

  pythonImportsCheck = [ "aniposelib" ];

  meta = {
    description = "An easy-to-use library for calibrating cameras in python ";
    homepage = "https://github.com/lambdaloop/aniposelib/tree/master";
  };
}
