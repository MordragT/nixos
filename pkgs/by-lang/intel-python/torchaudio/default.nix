{
  buildPythonPackage,
  fetchtorch,
  autoPatchelfHook,
  ffmpeg_6,
  sox,
  torch,
}:
buildPythonPackage rec {
  pname = "torchaudio";
  version = "2.9.1";
  format = "wheel";

  src = fetchtorch {
    inherit pname version;
    suffix = "%2Bxpu";
    platform = "manylinux_2_28_x86_64";
    hash = "sha256-CrEpTR7Qv0chlbkMioYckFBvWMJ6Qy1zQ9zKVV5+h2k=";
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

  pythonImportsCheck = [ "torchaudio" ];
}
