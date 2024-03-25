{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule {
  pname = "dud";
  version = "master";

  src = fetchFromGitHub {
    owner = "kevin-hanselman";
    repo = "dud";
    rev = "a3057b1a937a306a980aed200a7ec9ded08ac5a0";
    sha256 = "sha256-itxyYzuj1RGrGwgYqbxZ72cMNoARElkTkunDEuAokR4=";
  };

  vendorHash = "sha256-7223uF2c3sXLLQHn1YvSuE3Z5BHUv4W4Ga1KjqsJzAg=";

  meta = with lib; {
    description = "A lightweight CLI tool for versioning data alongside source code and building data pipelines.";
    homepage = "https://github.com/kevin-hanselman/dud";
    license = [licenses.bsd3];
    platforms = platforms.unix;
    maintainers = with maintainers; [mordrag];
  };
}
