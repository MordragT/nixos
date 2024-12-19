{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  decorator,
  imageio,
  imageio-ffmpeg,
  numpy,
  proglog,
  python-dotenv,
  pillow,
}:
buildPythonPackage rec {
  pname = "moviepy";
  version = "2.1.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Zulko";
    repo = "moviepy";
    rev = "refs/tags/v${version}";
    hash = "sha256-skfQbbWTXyTZjpehAcUdbyAPjZ5ZJoo69DAVWgCMF+k=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "pillow>=9.2.0,<11.0" "pillow>=9.2.0,<12.0"
  '';

  build-system = [setuptools];

  dependencies = [
    decorator
    imageio
    imageio-ffmpeg
    numpy
    proglog
    python-dotenv
    pillow
  ];

  pythonImportsCheck = ["moviepy"];
}
