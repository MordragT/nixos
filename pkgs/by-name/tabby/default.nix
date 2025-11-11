{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  git,
  openssl,
  pkg-config,
  protobuf,
  llama-cpp,
}: let
  llama-cpp' = llama-cpp.override {
    vulkanSupport = true;
  };
in
  rustPlatform.buildRustPackage rec {
    pname = "tabby";
    version = "0.31.2";

    passthru = {
      featureDevice = "vulkan";
    };

    src = fetchFromGitHub {
      owner = "TabbyML";
      repo = "tabby";
      rev = "v${version}";
      hash = "";
      fetchSubmodules = true;
    };

    cargoHash = "";

    # https://github.com/TabbyML/tabby/blob/v0.7.0/.github/workflows/release.yml#L39
    cargoBuildFlags = [
      "--release"
      "--package tabby"
      "--features vulkan"
    ];

    nativeBuildInputs = [
      pkg-config
      protobuf
      git
      makeWrapper
    ];

    buildInputs = [
      openssl
      llama-cpp'
    ];

    env = {
      OPENSSL_NO_VENDOR = 1;
    };

    patchPhase = ''
      rm crates/llama-cpp-server/build.rs
    '';

    postInstall = ''
      wrapProgram $out/bin/tabby --prefix PATH : ${lib.makeBinPath [git]}
      ln -s ${llama-cpp'}/bin/* $out/bin/
    '';

    # Fails with:
    # file cannot create directory: /var/empty/local/lib64/cmake/Llama
    doCheck = false;

    meta = with lib; {
      homepage = "https://github.com/TabbyML/tabby";
      changelog = "https://github.com/TabbyML/tabby/releases/tag/v${version}";
      description = "Self-hosted AI coding assistant";
      mainProgram = "tabby";
      license = licenses.asl20;
      maintainers = [maintainers.mordrag];
    };
  }
