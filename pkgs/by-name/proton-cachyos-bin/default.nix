{
  stdenv,
  lib,
  fetchzip,
  zstd,
}:
stdenv.mkDerivation rec {
  pname = "proton-cachyos-bin";
  version = "9.0.20241031-1";

  src = fetchzip {
    url = "https://mirror.cachyos.org/repo/x86_64_v3/cachyos-v3/proton-cachyos-1%3A${version}-x86_64_v3.pkg.tar.zst";
    hash = "sha256-J74WgquPsF1BeR3EgalWjlEk2TWHK9Ll42QpTe4J5uo=";
    nativeBuildInputs = [zstd];
    stripRoot = false;
  };

  outputs = ["out" "steamcompattool"];

  buildCommand = ''
    runHook preBuild

    # Make it impossible to add to an environment. You should use the appropriate NixOS option.
    # Also leave some breadcrumbs in the file.
    echo "Proton Cachyos should not be installed into environments. Please use programs.steam.extraCompatPackages instead." > $out

    ln -s $src/usr/share/steam/compatibilitytools.d/proton-cachyos $steamcompattool

    runHook postBuild
  '';

  meta = with lib; {
    license = licenses.bsd3;
    description = "Compatibility tool for Steam Play based on Wine and additional components.";
    homepage = "https://github.com/ValveSoftware/Proton";
    maintainers = with lib.maintainers; [Mordrag];
    platforms = platforms.linux;
  };
}
