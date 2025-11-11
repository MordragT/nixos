{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  vulkan-loader,
  lm_sensors,
  xorg,
}: let
  src = fetchFromGitHub {
    owner = "wiiznokes";
    repo = "fan-control";
    rev = "7d697b11ab0be1283b48123c97d1aaca56526d3c";
    hash = "sha256-CO/k+CL7p9DO7tbA6drehAqtLnHYowJ0EWVgibrz4ck=";
    fetchSubmodules = true;
  };

  # The package patches lm_sensors to provide more attributes
  sensors = lm_sensors.overrideAttrs (oldAttrs: {
    src = "${src}/hardware/libsensors";
  });
in
  rustPlatform.buildRustPackage rec {
    pname = "fan-control";
    version = "unstable-2025-11-09";

    inherit src;

    cargoHash = "sha256-3u4s7nG5otUrfjXiIO+Q4AHgdx9fijLeJtXtp+RG8sA=";

    nativeBuildInputs = [
      pkg-config
      rustPlatform.bindgenHook
    ];

    buildInputs = [
      libxkbcommon
      xorg.libX11
      xorg.libXi
      sensors
      vulkan-loader
    ];

    env = {
      LMSENSORS_PATH = "${sensors}";
    };

    # Force link against libs loaded at runtime
    # If -lvulkan is not forced, it falls back to X11 mode which hits this bug:
    # https://github.com/wiiznokes/fan-control/issues/98 (Create softbuffer surface for window)
    RUSTFLAGS = map (a: "-C link-arg=${a}") [
      "-Wl,--push-state,--no-as-needed"
      "-lvulkan"
      "-lsensors"
      "-lxkbcommon"
      "-lX11"
      "-lXi"
      "-Wl,--pop-state"
    ];

    postPatch = ''
      substituteInPlace ./ui/src/localize.rs ./data/src/localize.rs \
        --replace '#[folder = "./../i18n/"]' '#[folder = "${src}/i18n/"]'
    '';

    # Fails inside sandbox:
    # Linux(LmSensors("failed to init libsensor", LMSensors { operation: "sensors_init()", number: 4, description: "Kernel interface error" }))
    doCheck = false;

    passthru = {
      inherit sensors;
    };

    meta = {
      description = "Control your fans with different behaviors";
      homepage = "https://github.com/wiiznokes/fan-control";
      changelog = "https://github.com/wiiznokes/fan-control/blob/${src.rev}/CHANGELOG.md";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [mordrag];
      mainProgram = "fan-control";
      platforms = lib.platforms.linux;
    };
  }
