{ buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "dataclasses";
  version = "0.6";
  src = fetchPypi {
    inherit pname version;
    sha256 = "aYi9K4le70MtViNwu3B9VA8y9zYKsT2kU0AQG8IwfYQ=";
  };
}
