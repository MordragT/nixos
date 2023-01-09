{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, cmake
, pkg-config
, binutils
, gtk4
, libadwaita
, glib
, jsoncpp
, sqlitecpp
, sqlite
, boost
, desktop-file-utils
, shared-mime-info
}:

stdenv.mkDerivation rec {
  pname = "money";
  version = "2022.11.1";

  src = fetchFromGitHub {
    owner = "MordragT";
    repo = "NickvisionMoney";
    rev = "b5142fe457bc6472de02661ef475a6285e738e3e";
    sha256 = "SSQkBVL08bhK+ADX/AkfU7YrXjWmf2iNK9MTQ3F92Uc=";
  };

  nativeBuildInputs = [
    meson
    cmake
    pkg-config
    ninja
  ];

  buildInputs = [
    binutils
    libadwaita
    gtk4
    glib
    jsoncpp
    sqlitecpp
    sqlite
    boost
    desktop-file-utils
    shared-mime-info
  ];

  # https://github.com/NixOS/nixpkgs/issues/86131
  BOOST_INCLUDEDIR = "${lib.getDev boost}/include";
  BOOST_LIBRARYDIR = "${lib.getLib boost}/lib";

  #PKG_CONFIG_PATH = lib.makeSearchPath "lib/pkgconfig" buildInputs;
  #LD_LIBRARY_PATH = lib.makeLibraryPath buildInputs;

  meta = with lib; {
    license = licenses.gpl3;
    maintainers = with maintainers; [ mordrag ];
    description = "A personal finance manager ";
    platforms = platforms.linux;
  };
}
