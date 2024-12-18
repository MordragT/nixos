{
  python,
  buildPythonPackage,
  fetchtorch,
  autoPatchelfHook,
  ffmpeg_6,
  sox,
  torch,
}:
buildPythonPackage rec {
  pname = "torchaudio";
  version = "2.5.0.dev20241213";
  format = "wheel";

  src = fetchtorch {
    package = "${pname}-${version}";
    sha256 = "sha256-YDukH7wqgjVUEqcz7R4l7YUmbxcH0yy5xDCAB0MS1J0=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    torch.lib
    sox.lib
    ffmpeg_6.dev
  ];

  dependencies = [
    torch
  ];

  preFixup = ''
    # TorchAudio loads the newest FFmpeg that works, so get rid of the
    # old ones.
    rm $out/${python.sitePackages}/torio/lib/{lib,_}torio_ffmpeg{4,5}.*
  '';

  pythonImportsCheck = ["torchaudio"];
}
