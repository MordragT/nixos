{
  lib,
  rustPlatform,
  fetchurl,
  fetchFromGitHub,
  makeWrapper,
  git,
  openssl,
  pkg-config,
  protobuf,
  llama-cpp,
  llama-cpp-sycl,
  acceleration ? "cpu",
}: let
  enableSycl = acceleration == "sycl";
  enableVulkan = acceleration == "vulkan";
  llama-cpp' =
    if enableSycl
    then llama-cpp-sycl
    else
      (llama-cpp.override {
        vulkanSupport = enableVulkan;
      });
  featureDevice =
    if acceleration == "sycl"
    then "cpu"
    else acceleration;
in
  rustPlatform.buildRustPackage rec {
    pname = "tabby";
    version = "0.14.0";

    passthru = {
      inherit featureDevice;
    };

    src = fetchFromGitHub {
      owner = "TabbyML";
      repo = "tabby";
      rev = "v${version}";
      hash = "sha256-zB2+rMU0vRl06dQHER1H5Dty04vKYImg2VsLJAkqhjc=";
      fetchSubmodules = true;
    };

    cargoLock = {
      lockFile = fetchurl {
        url = "https://raw.githubusercontent.com/TabbyML/tabby/v${version}/Cargo.lock";
        hash = "sha256-BWGaapDmCmzlK1XsXJ8ZE6X1FC4NqRJSWVk4EC5LWtc=";
      };
      allowBuiltinFetchGit = true;
    };

    # https://github.com/TabbyML/tabby/blob/v0.7.0/.github/workflows/release.yml#L39
    cargoBuildFlags =
      [
        "--release"
        "--package tabby"
      ]
      ++ lib.optionals enableVulkan [
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

    patchPhase =
      ''
        rm crates/llama-cpp-server/build.rs
      ''
      + lib.optionalString enableSycl ''
        substituteInPlace crates/llama-cpp-server/src/supervisor.rs \
          --replace-fail '.arg("-m")' '.arg("-sm").arg("none").arg("-m")'
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
