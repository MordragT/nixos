{
  stdenvNoCC,
  lib,
  gnutar,
  zstd,
}:
stdenvNoCC.mkDerivation rec {
  pname = "proton-cachyos";
  version = "9.0-11";

  src = builtins.fetchurl {
    url = "https://mirror.cachyos.org/repo/x86_64_v3/cachyos-v3/proton-cachyos-${version}-x86_64_v3.pkg.tar.zst";
    sha256 = "1pnm9r04kiq6wc5rmvwjpbxr5g1alsgjd9iz53jnm2w4m3awpnb8";
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
