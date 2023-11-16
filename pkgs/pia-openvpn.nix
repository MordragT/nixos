{
  stdenv,
  fetchurl,
  unzip,
}:
stdenv.mkDerivation {
  name = "pia-openvpn";
  src = fetchurl {
    url = "https://www.privateinternetaccess.com/openvpn/openvpn.zip";
    sha256 = "vDhCd4Ku3JDLZbMizW+ddK9OmIzFs8iE5DI27XpeRJE=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
  ];

  installPhase = ''
    mkdir -p $out;
    cp *.ovpn $out/
  '';
}
