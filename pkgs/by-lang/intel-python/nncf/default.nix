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
let
  version = "3.4.0";
in
buildPythonPackage {
  pname = "nncf";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openvinotoolkit";
    repo = "nncf";
    rev = "v${version}";
    hash = "sha256-PsInhbHmTrnP/STSpCqSfXpd6CAIYR4Ah3bbxu3lfuo=";
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
    "numpy"
  ];

  pythonRemoveDeps = [
    "openvino-telemetry"
  ];

  postPatch = ''
    substituteInPlace ./src/custom_version.py \
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
