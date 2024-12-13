{
  python,
  buildPythonPackage,
  fetchipex,
  autoPatchelfHook,
  ffmpeg_6,
  torch,
}:
buildPythonPackage rec {
  pname = "torchaudio";
  version = "2.3.1";
  format = "wheel";

  src = fetchipex {
    package = "${pname}-${version}";
    abi = "%2Bcxx11.abi";
    sha256 = "sha256-nScE7PUXLPKPi0Ces9qcQme5IQqBbdkjOPn/yM+0Xfw=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    torch.lib
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
