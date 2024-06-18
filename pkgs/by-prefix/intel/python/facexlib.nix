{
  buildPythonPackage,
  cython,
  fetchPypi,
  filterpy,
  numba,
  numpy,
  opencv4,
  pillow,
  scipy,
  torch,
  torchvision,
  tqdm,
}:
buildPythonPackage rec {
  pname = "facexlib";
  version = "0.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1r378mb167k2hynrn1wsi78xbh2aw6x68i8f70nmcqsxxp20rqii";
  };

  patches = [./facexlib.patch];

  buildInputs = [cython numpy];

  dependencies = [
    filterpy
    numba
    numpy
    numpy
    opencv4
    pillow
    scipy
    torch
    torchvision
    tqdm
  ];

  # TODO FIXME
  doCheck = false;

  meta = {
    description = "Basic face library";
    homepage = "https://github.com/xinntao/facexlib";
  };
}
