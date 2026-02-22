{
  buildPythonPackage,
  fetchPypi,
  flit,
}:
buildPythonPackage rec {
  pname = "ajc27_freemocap_blender_addon";
  version = "2025.1.1035";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tumcCcoFrSuvyzvXr72THqg71TfzSQKyiW5rUimmNA0=";
  };

  build-system = [
    flit
  ];

  pythonImportsCheck = [ "ajc27_freemocap_blender_addon" ];

  meta = {
    description = "A Blender add-on for loading and visualizing motion capture data recorded with the FreeMoCap software.";
    homepage = "https://freemocap.org/";
  };
}
