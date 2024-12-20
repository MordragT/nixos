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
  version = "2.5.0.dev20241220";
  format = "wheel";

  src = fetchtorch {
    package = "${pname}-${version}";
    sha256 = "";
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
