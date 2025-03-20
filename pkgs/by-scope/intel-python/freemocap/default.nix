{
  buildPythonPackage,
  fetchPypi,
  pythonRelaxDepsHook,
  blender,
  flit,
  skellycam,
  skelly-viewer,
  skellyforge,
  skelly-synchronize,
  skellytracker,
  freemocap-blender-addon,
  opencv4,
  toml,
  aniposelib,
  libsass,
  ipykernel,
  plotly,
  pydantic,
  pyside6,
  pytest,
}:
buildPythonPackage rec {
  pname = "freemocap";
  version = "1.5.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xcZmAyd/PrTkTreJJEWwpPS3nh70OazI/DoHhQN0nas=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  buildInputs = [
    blender
  ];

  build-system = [
    flit
  ];

  dependencies = [
    skellycam
    skelly-viewer
    skellyforge
    skelly-synchronize
    skellytracker
    skellytracker.optional-dependencies.mediapipe
    freemocap-blender-addon
    opencv4
    toml
    aniposelib
    libsass
    ipykernel
    plotly
    pydantic
    pyside6
    pytest
  ];

  pythonRemoveDeps = [
    "opencv-contrib-python"
  ];

  pythonRelaxDeps = [
    "skellycam"
    "skelly_synchronize"
    "aniposelib"
    "libsass"
    "ipykernel"
    "plotly"
    "pyside6"
    "packaging"
  ];

  postPatch = ''
    substituteInPlace ./freemocap/core_processes/export_data/blender_stuff/get_best_guess_of_blender_path.py \
      --replace-fail "/usr/bin" "${blender}/bin"
  '';

  # pythonImportsCheck = [];

  meta = {
    description = "Free Motion Capture for Everyone 💀✨";
    homepage = "https://freemocap.org/";
  };
}
