{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  jsonschema,
  jstyleson,
  natsort,
  networkx,
  ninja,
  numpy,
  packaging,
  pandas,
  psutil,
  pydot,
  pymoo,
  rich,
  scikit-learn,
  scipy,
  tabulate,
  tqdm,
  safetensors,
  kaleido,
  matplotlib,
  pillow,
  plotly,
}:
buildPythonPackage rec {
  pname = "nncf";
  version = "2.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openvinotoolkit";
    repo = "nncf";
    rev = "v${version}";
    hash = "sha256-0hrmJI8pnAAtC8D2WnUKxu5rEpXwBQ2mIUxVoX9m2/E=";
  };
  build-system = [
    setuptools
  ];

  dependencies = [
    jsonschema
    jstyleson
    natsort
    networkx
    ninja
    numpy
    packaging
    pandas
    psutil
    pydot
    pymoo
    rich
    scikit-learn
    scipy
    tabulate
    tqdm
    safetensors
  ];

  optional-dependencies = {
    plots = [
      kaleido
      matplotlib
      pillow
      plotly # "plotly-express>=0.4.1",
    ];
  };

  pythonRelaxDeps = [
    "ninja"
  ];

  pythonRemoveDeps = [
    "openvino-telemetry"
  ];

  # postPatch = ''
  #   substituteInPlace ./pyproject.toml \
  #     --replace-fail 'version = { attr = "custom_version.version" }' 'version = "${version}"'
  # '';

  postPatch = ''
    substituteInPlace ./custom_version.py \
      --replace-fail 'version = get_custom_version()' 'version = "${version}"'
  '';

  doCheck = false;

  pythonImportsCheck = [ "nncf" ];

  meta = {
    description = " Neural Network Compression Framework for enhanced OpenVINO™ inference ";
    homepage = "https://github.com/openvinotoolkit/nncf/tree/develop";
    changelog = "https://github.com/openvinotoolkit/nncf/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mordrag ];
  };
}
