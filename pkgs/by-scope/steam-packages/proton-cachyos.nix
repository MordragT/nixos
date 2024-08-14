{
  stdenvNoCC,
  lib,
  gnutar,
  zstd,
  fetchurl,
}:
stdenvNoCC.mkDerivation rec {
  pname = "Proton Cachyos";
  version = "9.0.20240708-1";

  src = fetchurl {
    url = "https://mirror.cachyos.org/repo/x86_64_v3/cachyos-v3/proton-cachyos-1%3A${version}-x86_64_v3.pkg.tar.zst";
    hash = "sha256-wKGTejwGaHS9da5mzfFGJyyVyte3N7JOfrnXi+37wno=";
  };

  nativeBuildInputs = [gnutar zstd];

  unpackPhase = ''
    tar xf $src
  '';

  installPhase = ''
    mkdir -p $out
    mv usr/share/steam/compatibilitytools.d/proton-cachyos $out/bin
  '';

  meta = with lib; {
    license = licenses.bsd3;
    description = "Compatibility tool for Steam Play based on Wine and additional components.";
    homepage = "https://github.com/ValveSoftware/Proton";
    maintainers = with lib.maintainers; [Mordrag];
    platforms = platforms.linux;
  };
}
