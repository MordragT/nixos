{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  vulkan-loader,
  lm_sensors,
  libX11,
  libXi,
}:
let
  version = "26.01";
  src = fetchFromGitHub {
    owner = "wiiznokes";
    repo = "fan-control";
    rev = version;
    hash = "sha256-tIR+e8u50Km8DzGPm2YzyJAlV6lo3qRlnRsUx57I9Zg=";
    fetchSubmodules = true;
  };

  # The package patches lm_sensors to provide more attributes
  sensors = lm_sensors.overrideAttrs (oldAttrs: {
    src = "${src}/hardware/libsensors";
  });
in
rustPlatform.buildRustPackage rec {
  inherit version src;

  pname = "fan-control";
  cargoHash = "sha256-tA0Pvne3+lzvablVhwHClYeKB/3u+07RNrtSYo08lV0=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    libxkbcommon
    libX11
    libXi
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
    maintainers = with lib.maintainers; [ mordrag ];
    mainProgram = "fan-control";
    platforms = lib.platforms.linux;
  };
}
