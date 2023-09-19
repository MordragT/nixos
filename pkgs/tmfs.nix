{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  gcc,
  fuse,
  pkg-config,
}:
stdenv.mkDerivation {
  pname = "tmfs";
  version = "0.7";

  src = fetchFromGitHub {
    sha256 = "55iQz5EFJlxDCOIwt1YbbBOaVOWjiVySDmekIhyV4sg=";
    rev = "27d5749";
    owner = "abique";
    repo = "tmfs";
  };

  buildInputs = [
    fuse
  ];

  nativeBuildInputs = [
    cmake
    gcc
    pkg-config
  ];

  meta = with lib; {
    description = "Apple's Time Machine fuse read only file system";
    longDescription = ''
      Time Machine File System is a read-only virtual filesystem
      which helps you to read your Apple's time machine backup.
      This filesystem does not targets performances,
      it has been written for a friend who has lost his macbook
      and wants to recover its data on Linux.
    '';
    homepage = "https://hpc.fau.de/research/tools/likwid/";
    license = [licenses.mit];
    platforms = platforms.unix;
    maintainers = with maintainers; [mordrag];
  };
}
