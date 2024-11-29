{
  buildPythonPackage,
  fetchwheel,
  autoPatchelfHook,
  ffmpeg_4,
  ffmpeg_5,
  ffmpeg_6,
  torch,
}:
buildPythonPackage rec {
  pname = "torchaudio";
  version = "2.3.1";
  format = "wheel";

  src = fetchwheel {
    package = "${pname}-${version}";
    sha256 = "sha256-nScE7PUXLPKPi0Ces9qcQme5IQqBbdkjOPn/yM+0Xfw=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    torch.lib
    ffmpeg_4.dev
    ffmpeg_5.dev
    ffmpeg_6.dev
  ];

  dependencies = [
    torch
  ];

  meta.broken = true;
}
