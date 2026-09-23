{
  buildPythonPackage,
  fetchtorch,
  autoPatchelfHook,
  ffmpeg_6,
  sox,
  torch,
}:
let
  pname = "torchaudio";
  version = "2.11.0";
in
buildPythonPackage {
  inherit pname version;
  format = "wheel";

  src = fetchtorch {
    inherit pname version;
    suffix = "%2Bxpu";
    hash = "sha256-L7h8rntpua+EosqFksBy3H52o4UZ1KFXQc8rKMDevV4=";
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
