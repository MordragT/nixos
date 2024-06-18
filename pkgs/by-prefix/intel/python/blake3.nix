{
  buildPythonPackage,
  fetchPypi,
  rustPlatform,
  python,
}:
buildPythonPackage rec {
  pname = "blake3";
  version = "0.4.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BiXIZ5ID1aHTD4WWlqP9dbL1BYeYRpCtq4Oe8RL0wEM=";
  };

  # Without this, when building for PyPy, `maturin build` seems to fail to
  # find the interpreter at all and then fails early in the build process with
  # an error saying "unsupported Python interpreter".  We can easily point
  # directly at the relevant interpreter, so do that.
  maturinBuildFlags = ["--interpreter" python.executable];

  nativeBuildInputs = with rustPlatform; [
    maturinBuildHook
    cargoSetupHook
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-G1z9Ye7k1UK+nySpjrpgNL/a+ozNq+d1VrIn7bh7fE8=";
  };

  # TODO FIXME
  doCheck = false;

  meta = {
    description = " Python bindings for the BLAKE3 cryptographic hash function";
    homepage = "https://github.com/oconnor663/blake3-py";
  };
}
