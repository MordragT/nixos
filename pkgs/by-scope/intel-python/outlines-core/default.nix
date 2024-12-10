{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  rustPlatform,
  cargo,
  rustc,
  openssl,
  pkg-config,
  setuptools-rust,
  setuptools-scm,
  interegular,
  jsonschema,
  datasets,
  numpy,
  pytestCheckHook,
  pydantic,
  scipy,
  torch,
  transformers,
}:
buildPythonPackage rec {
  pname = "outlines-core";
  version = "0.1.24";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "outlines_core";
    hash = "sha256-5vpvJviTZTQj6nQvPKTa67wygD8ET+aap/aoVjX0APk=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    cp --no-preserve=mode ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  build-system = [
    setuptools-rust
    setuptools-scm
  ];

  dependencies = [
    interegular
    jsonschema
  ];

  optional-dependencies = {
    tests = [
      datasets
      numpy
      pydantic
      scipy
      torch
      transformers
    ];
  };

  nativeCheckInputs = [pytestCheckHook] ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTests = [
    # Tests that need to download from Hugging Face Hub.
    "test_create_fsm_index_tokenizer"
    "test_reduced_vocabulary_with_rare_tokens"
    "test_complex_serialization"
  ];

  pythonImportsCheck = ["outlines_core"];

  meta = {
    description = "Structured text generation (core)";
    homepage = "https://github.com/outlines-dev/outlines-core";
    changelog = "https://github.com/dottxt-ai/outlines-core/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [danieldk];
  };
}
