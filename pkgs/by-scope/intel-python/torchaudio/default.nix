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
  version = "2.7.1";
  format = "wheel";

  src = fetchtorch {
    inherit pname version;
    suffix = "%2Bxpu";
    platform = "manylinux_2_28_x86_64";
    hash = "";
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
