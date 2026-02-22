{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "dud";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "kevin-hanselman";
    repo = "dud";
    rev = "v${version}";
    sha256 = "sha256-A/mg3uXKreb/RHwjO8pZ11IkMd9vX8Hd/wgJoVz2Z4A=";
  };

  vendorHash = "sha256-mKvqAoyJ0D9Qtv4KXeDr+gT1lp61mIhNJnVDEiQNTuM=";

  meta = with lib; {
    description = "A lightweight CLI tool for versioning data alongside source code and building data pipelines.";
    homepage = "https://github.com/kevin-hanselman/dud";
    license = [ licenses.bsd3 ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ mordrag ];
  };
}
