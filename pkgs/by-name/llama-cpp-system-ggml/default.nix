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
  ggml,
  openssl,
  curl,
}:
let
  inherit (lib) cmakeBool cmakeFeature;

  # Upstream reads these from git, which the release tarball does not ship.
  # They are purely informational: `llama-server --version`, `/props`, and the web UI.
  buildNumber = "11669";
  buildCommit = "620d222";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "llama-cpp";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "ggerganov";
    repo = "llama.cpp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pEDYgI3AMTU+cekvRX7NNt5wddznydQSNuerswvEpsA=";
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
    ggml
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
  npmDepsHash = "sha256-hqYzdp1FwPhYkBP278fQXgY9NCKB6Q3P6Gko7BfP0m0=";
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
