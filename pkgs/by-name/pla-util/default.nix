{
  lib,
  stdenv,
  fetchFromGitHub,
  gprbuild,
  gnat,
  libpcap,
}:
stdenv.mkDerivation rec {
  pname = "pla-util";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "serock";
    repo = pname;
    rev = version;
    hash = "sha256-L25k+pPZgkX+8MMgJQusRDlMd42HuuqzMaMXp6bcoNg=";
  };

  # makeFlags = [
  #   "prefix=$(out)"
  # ];

  nativeBuildInputs = [
    gprbuild
    gnat
  ];

  buildInputs = [
    libpcap
  ];

  buildPhase = ''
    runHook preBuild

    gprbuild

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/pla-util $out/bin/pla-util

    runHook postInstall
  '';

  meta = {
    description = "A power line adapter utility for Linux ";
    homepage = "https://github.com/serock/pla-util";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mordrag ];
    platforms = lib.platforms.linux;
  };
}
