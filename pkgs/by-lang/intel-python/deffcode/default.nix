{
  buildPythonPackage,
  fetchPypi,
  pythonRelaxDepsHook,
  ffmpeg,
  setuptools,
  numpy,
  requests,
  colorlog,
  tqdm,
}:
buildPythonPackage rec {
  pname = "deffcode";
  version = "0.2.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ejZwyCpVQxbjqv3P1XVQZPwDMbBUgX+Oa32BxUlglpI=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  buildInputs = [ ffmpeg ];

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    requests
    colorlog
    tqdm
  ];

  pythonRemoveDeps = [
    "cython"
  ];

  pythonImportsCheck = [ "deffcode" ];

  meta = {
    description = "A cross-platform High-performance & Flexible Real-time Video Frames Decoder in Python.";
    homepage = "https://abhitronix.github.io/deffcode/latest/";
  };
}
