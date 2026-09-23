{
  lib,
  rustPlatform,
  fetchFromGitHub,
  writeShellScriptBin,
  pkg-config,
  cmake,
  espeak-ng,
  onnxruntime,
  libopus,
  openssl,
  makeWrapper,
}:
let
  version = "b17";

  # Pre-fetch sonic for espeak-ng's FetchContent
  sonicSrc = fetchFromGitHub {
    owner = "waywardgeek";
    repo = "sonic";
    rev = "b93885dcb70aae50c6f76b0fe4e0868f029a077e";
    hash = "sha256-kKMAjoLdC3y9vx7rw80+T1r/QZ2miBjJCIAOs3fm2dg=";
  };

  # Inject sonic and offline mode into every cmake configure call,
  # pass --build/--install invocations through untouched
  cmakeWrapped = writeShellScriptBin "cmake" ''
    IS_BUILD=0
    for arg in "$@"; do
      if [[ "$arg" == "--build" || "$arg" == "--install" ]]; then
        IS_BUILD=1
        break
      fi
    done

    if [[ "$IS_BUILD" -eq 1 ]]; then
      exec ${cmake}/bin/cmake "$@"
    else
      exec ${cmake}/bin/cmake \
        -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
        -DFETCHCONTENT_SOURCE_DIR_SONIC-GIT=${sonicSrc} \
        -DFETCHCONTENT_FULLY_DISCONNECTED=ON \
        "$@"
    fi
  '';
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kokoros";
  inherit version;

  src = fetchFromGitHub {
    owner = "lemonade-sdk";
    repo = "Kokoros";
    rev = version;
    hash = "sha256-CJS3/miLNku6RytXCQS6z0D476cZ+l0F18ofsGvMZMQ=";
  };

  cargoHash = "sha256-tp7WKN98ferSunUS0Z0db223kJ4lpx8MQkyfc42xQ+E=";

  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    cmakeWrapped
    rustPlatform.bindgenHook
    makeWrapper
  ];

  buildInputs = [
    espeak-ng
    onnxruntime
    libopus
    openssl
  ];

  env = {
    # Tell ort to use system libraries instead of downloading
    ORT_STRATEGY = "system";
    ORT_LIB_LOCATION = "${lib.getLib onnxruntime}/lib";
    ORT_PREFER_DYNAMIC_LINK = "1";
  };

  postInstall = ''
    wrapProgram $out/bin/koko \
      --set ESPEAK_DATA_PATH "${espeak-ng}/share/espeak-ng-data"
  '';

  meta = {
    description = "Insanely fast Kokoro TTS inference in Rust";
    homepage = "https://github.com/lemonade-sdk/Kokoros";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "koko";
  };
})
