{
  lib,
  cmake,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  pkg-config,
  ninja,
  nodejs,
  npmHooks,
  ggml-sycl,
  openssl,
  curl,
}:
let
  inherit (lib) cmakeBool cmakeFeature;

  # Upstream reads these from git, which the release tarball does not ship.
  # They are purely informational: `llama-server --version`, `/props`, and the web UI.
  buildNumber = "10809";
  buildCommit = "5266f24";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "llama-cpp";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ggerganov";
    repo = "llama.cpp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WImZjO3U9EXZUNP/FMpxo8PaTjQW8X2SBTfGwwFlZIM=";
  };

  patches = [ ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    nodejs
    npmHooks.npmConfigHook
  ];

  buildInputs = [
    ggml-sycl
    openssl
    curl
  ];

  cmakeFlags = [
    (cmakeBool "BUILD_SHARED_LIBS" true)
    (cmakeBool "LLAMA_BUILD_EXAMPLES" false)
    (cmakeBool "LLAMA_BUILD_SERVER" true)
    (cmakeBool "LLAMA_OPENSSL" true)
    (cmakeBool "LLAMA_USE_SYSTEM_GGML" true)
    (cmakeFeature "LLAMA_BUILD_NUMBER" buildNumber)
    (cmakeFeature "LLAMA_BUILD_COMMIT" buildCommit)
  ];

  npmRoot = "tools/ui";
  npmDepsHash = "sha256-2Q7XhaLAArmviOLdQsNbYTfdyDE5pW9lR26cRHEVl9k=";
  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src patches;
    preBuild = ''
      pushd ${finalAttrs.npmRoot}
    '';
    hash = finalAttrs.npmDepsHash;
  };

  preConfigure = ''
    pushd ${finalAttrs.npmRoot}
    LLAMA_BUILD_NUMBER=${buildNumber} npm run build
    popd
  '';

  meta = with lib; {
    description = "Port of Facebook's LLaMA model in C/C++";
    homepage = "https://github.com/ggerganov/llama.cpp/";
    license = licenses.mit;
    mainProgram = "llama";
    maintainers = with maintainers; [ mordrag ];
    platforms = platforms.unix;
  };
})
