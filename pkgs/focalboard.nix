{ stdenv
, fetchFromGitHub
, go
, nodejs
}:

stdenv.mkDerivation rec {
  pname = "focalboard";
  version = "7.4.2";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "focalboard";
    rev = "2b984d45b28e165efab58b78246e6c5c98e6f23c";
    sha256 = "lnmng5T6liLNkoetE+4/8lMTi9+iLNmUDHE/HMm6ZIc=";
  };

  nativeBuildInputs = [ go nodejs ];

  buildPhase = ''
    npm install --prefix project webapp/
    make linux-app
  '';

  installPhase = ''
    ls
  '';

  meta = with lib; {
    maintainers = with maintainers; [ mordrag ];
    platforms = platforms.linux;
    broken = true;
  };
}
