{
  python,
  buildPythonPackage,
  fetchipex,
  autoPatchelfHook,
  ffmpeg_6,
  torch-ipex,
}:
buildPythonPackage rec {
  pname = "torchaudio";
  version = "2.5.1";
  format = "wheel";

  src = fetchipex {
    inherit pname version;
    suffix = "%2Bcxx11.abi";
    hash = "sha256-OZKMZm16OMpZrR0WVybLhrhzbSsTC3rJLPDl50+WDQI=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    torch-ipex.lib
    ffmpeg_6.dev
  ];

  dependencies = [
    torch-ipex
  ];

  preFixup = ''
    # TorchAudio loads the newest FFmpeg that works, so get rid of the
    # old ones.
    rm $out/${python.sitePackages}/torio/lib/{lib,_}torio_ffmpeg{4,5}.*
  '';

  pythonImportsCheck = ["torchaudio"];
}
