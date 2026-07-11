{
  stdenv,
  lib,
  fetchzip,
  zstd,
}:
let
  version = "11.0-20260602";
in

stdenv.mkDerivation {
  pname = "proton-cachyos-bin";
  inherit version;

  src = fetchzip {
    url = "https://github.com/CachyOS/proton-cachyos/releases/download/cachyos-${version}-slr/proton-cachyos-${version}-slr-x86_64_v3.tar.xz";
    hash = "sha256-093fO6oOBFnyJNbqr0em+sK5/YyxHQBE7BfV2JDAitE=";
    nativeBuildInputs = [ zstd ];
    stripRoot = false;
  };

  outputs = [
    "out"
    "steamcompattool"
  ];

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
    maintainers = with lib.maintainers; [ Mordrag ];
    platforms = platforms.linux;
  };
}
