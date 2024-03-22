{
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation rec {
  pname = "wine-ge";
  version = "8-27-LoL";

  src = builtins.fetchurl {
    url = "https://github.com/GloriousEggroll/wine-ge-custom/releases/download/GE-Proton${version}/wine-lutris-GE-Proton${version}-x86_64.tar.xz";
    sha256 = "1a6rxnw3bpnpwsp2v6fwl4x50dpdgnrw3p5kg7xic7hyrpvilbax";
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
