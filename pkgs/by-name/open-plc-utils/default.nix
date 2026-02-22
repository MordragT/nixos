{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "open-plc-utils";
  version = "unstable-2025-07-12";

  src = fetchFromGitHub {
    owner = "qca";
    repo = "open-plc-utils";
    rev = "46c3506453c15b873fd6ed3e76c9872cea5e143a";
    hash = "sha256-KjvJFCYClNloOtPwFi1mU9xIoiYYcz7oIfw+9y3RtN4=";
  };

  makeFlags = [
    "ROOTFS=$(out)"
    "BIN=$(out)/bin"
    "MAN=$(out)/share/man/man1"
    "DOC=$(out)/share/doc"
    "WWW=$(out)/share/www"
    "FTP=$(out)/share/ftp"
    "SUID_PERM=0555"
  ];

  postConfigure = ''
    makeFlagsArray+=(
        "OWNER=$(id -u)"
        "GROUP=$(id -g)"
    )
  '';

  meta = {
    description = "Qualcomm Atheros Open Powerline Toolkit.";
    homepage = "https://github.com/qca/open-plc-utls";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mordrag ];
    platforms = lib.platforms.linux;
  };
}
