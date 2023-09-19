{
  buildPythonPackage,
  fetchPypi,
  tokenize-rt,
}:
buildPythonPackage rec {
  pname = "future_annotations";
  version = "1.0.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "xwfRn3x04I2eZ7MQ/Wp0OP9RC6XL+3M0aVYn+PacY3g=";
  };

  propagatedBuildInputs = [
    tokenize-rt
  ];
}
