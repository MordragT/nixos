{
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  click,
  click-option-group,
  zeroconf,
  rich,
  python-slugify,
  typing-extensions,
}:
buildPythonPackage rec {
  pname = "mdns-beacon";
  version = "0.8.1";

  src = fetchPypi {
    inherit version;
    pname = "mdns_beacon";
    hash = "sha256-oG12XvkKxQSTHBFpEbMC6vNRwLjpSY8ZyqRgKEH+syo=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace poetry.masonry.api poetry.core.masonry.api \
    --replace "poetry>=" "poetry-core>=" \
    --replace 'zeroconf = "^0.119.0"' 'zeroconf = "*"'
  '';

  # do not run tests
  doCheck = false;

  # specific to buildPythonPackage, see its reference
  pyproject = true;
  build-system = [
    poetry-core
  ];

  propagatedBuildInputs = [
    click
    click-option-group
    zeroconf
    rich
    python-slugify
    typing-extensions
  ];
}
