{
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
  perl,
  libz,
  libxml2,
  ncurses,
}: {
  pins = import ./pins.nix {
    inherit fetchFromGitHub;
  };
  mkLLVM = {
    stdenv,
    name,
    cmakeFlags ? [],
    targetDir ? name,
    extraBuildInputs ? [],
    buildPhase ? "",
    passthru ? {},
    env ? {},
  }:
    stdenv.mkDerivation rec {
      inherit cmakeFlags passthru buildPhase env;

      pname = "intel-${name}";
      version = "19.0.0-unstable-2024-04-15";

      src = fetchFromGitHub {
        rev = "06bd6bca82e1ba93e2e233cac9b86631e6c2d958";
        owner = "intel";
        repo = "llvm";
        hash = "sha256-o3QERO8DRnHyQ84WBuDvj46qJT4ZVB3A94QHVIrriIU=";
      };

      sourceRoot = "${src.name}/${targetDir}";

      nativeBuildInputs = [
        cmake
        pkg-config
        python3
        perl
      ];

      buildInputs =
        [
          libz
          libxml2
          ncurses
        ]
        ++ extraBuildInputs;
    };
}
