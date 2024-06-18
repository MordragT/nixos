{
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation rec {
  pname = "wine-ge";
  version = "8-26";

  src = builtins.fetchurl {
    url = "https://github.com/GloriousEggroll/wine-ge-custom/releases/download/GE-Proton${version}/wine-lutris-GE-Proton${version}-x86_64.tar.xz";
    sha256 = "020fb93kcd4lhs1982x5rm2d386cxr9dwg1v4nbbld7dksmscnm9";
  };

  buildCommand = ''
    mkdir -p $out
    tar xf $src --directory=$out --strip=1
  '';

  meta = with lib; {
    license = licenses.bsd3;
    description = "My custom build of wine, made to use with lutris. Built with lutris's buildbot. ";
    homepage = "https://github.com/GloriousEggroll/wine-ge-custom";
    maintainers = with lib.maintainers; [Mordrag];
    platforms = platforms.linux;
  };
}
