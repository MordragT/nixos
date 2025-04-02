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
    sha256 = "";
  };

  vendorHash = "";

  meta = with lib; {
    description = "A lightweight CLI tool for versioning data alongside source code and building data pipelines.";
    homepage = "https://github.com/kevin-hanselman/dud";
    license = [licenses.bsd3];
    platforms = platforms.unix;
    maintainers = with maintainers; [mordrag];
  };
}
