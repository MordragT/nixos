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
  version = "2.1.0.post2";
  format = "wheel";

  src = fetchwheel {
    package = "${pname}-${version}";
    sha256 = "sha256-3PE2z1/OGrFaj4ovz1OjnrURplgQvmRgaTCxpgJtXYU=";
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
}
