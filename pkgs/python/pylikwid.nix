{ buildPythonPackage, fetchPypi, likwid }:

buildPythonPackage rec {
  pname = "pylikwid";
  version = "0.4.2";
  src = fetchPypi {
    inherit pname version;
    sha256 = "ayddGttYWGdJ4mZ1yRgYZriF64inDAM+e4JHUyXnDLQ=";
  };

  LIKWID_PREFIX = "${likwid}";

  propagatedBuildInputs = [
    likwid
  ];
}
