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
    package = "${pname}-${version}";
    abi = "%2Bcxx11.abi";
    sha256 = "";
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
