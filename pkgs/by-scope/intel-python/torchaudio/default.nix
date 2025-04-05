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
  version = "2.6.0";
  format = "wheel";

  src = fetchtorch {
    inherit pname version;
    suffix = "%2Bxpu";
    hash = "sha256-+h80XlWUdfBxHP5j3XiM+ltsWoUB2KgGNC79tIEM4wc=";
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
