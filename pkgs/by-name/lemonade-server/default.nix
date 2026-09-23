# Credits to: https://github.com/michnicki/lemonade-nix
{
  lib,
  fetchFromGitHub,
  stdenv,
  nodejs,
  cacert,
  cmake,
  ninja,
  pkg-config,
  nlohmann_json,
  cli11,
  curl,
  zstd,
  openssl,
  mbedtls,
  systemd,
  libcap,
  libdrm,
}:
let

  version = "11.9.0";

  lemonade-src = fetchFromGitHub {
    owner = "lemonade-sdk";
    repo = "lemonade";
    rev = "v${version}";
    hash = "sha256-ZXhQWk1zCaIAM9vJC1TFPY4mfi/oKGoLuRSEtwG/wo8=";
  };

  # cpp-httplib is not packaged in nixpkgs; pre-fetch for FetchContent.
  cpp-httplib-src = fetchFromGitHub {
    owner = "yhirose";
    repo = "cpp-httplib";
    rev = "v0.26.0";
    hash = "sha256-+VPebnFMGNyChM20q4Z+kVOyI/qDLQjRsaGS0vo8kDM=";
  };

  # IXWebSocket was replaced by libwebsockets in v10.0.1.
  libwebsockets-src = fetchFromGitHub {
    owner = "warmcat";
    repo = "libwebsockets";
    rev = "v4.3.3";
    hash = "sha256-IXA9NUh55GtZmn4BhCXntVdHcKZ34iZIJ/0wlySj0/M=";
  };

  # Build the web app separately as a fixed-output derivation so npm can
  # access the network. The main cmake build keeps BUILD_WEB_APP=OFF to
  # avoid running npm in the sandbox; we inject the pre-built assets in
  # postInstall instead.
  lemonade-webapp = stdenv.mkDerivation {
    name = "lemonade-webapp";
    src = lemonade-src;

    nativeBuildInputs = [
      nodejs
      cacert
    ];

    # The web-app build expects src/app and src/web-app to be siblings.
    unpackPhase = ''
      cp -rL $src/src/app app
      cp -rL $src/src/web-app webapp
      chmod -R u+w app webapp
    '';

    buildPhase = ''
      cd webapp
      export HOME=$(mktemp -d)
      export npm_config_cache=$(mktemp -d)
      export NODE_EXTRA_CA_CERTS="${cacert}/etc/ssl/certs/ca-bundle.crt"
      npm install
      mkdir -p $out
      WEBPACK_OUTPUT_PATH=$out node ./node_modules/.bin/webpack --mode production
    '';

    installPhase = ":";

    # Fixed-output derivation: allows network access; hash ensures
    # reproducibility. Run `nix build` with this fake hash to get the
    # real one from the error output, then replace it below.
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-epUbCGYHdOE9VJV4qy/n7xH8qZs/2q8V4at9dNtH2Tg=";

    dontStrip = true;
    dontFixup = true;
  };

in

stdenv.mkDerivation {
  pname = "lemonade-server";
  inherit version;

  src = lemonade-src;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    nlohmann_json
    cli11
    curl
    zstd
    openssl
    # v10.7.0 added mbedTLS for download digest verification. Upstream
    # prefers system mbedcrypto (via pkg-config) and only falls back to a
    # network FetchContent git-clone otherwise, which the sandbox blocks.
    mbedtls
    systemd
    libcap
    libdrm
  ];

  postPatch = ''
    # Make resource lookup work for FHS install layout:
    # binary at $prefix/bin/, resources at $prefix/share/lemonade-server/
    sed -i 's|std::vector<std::string> install_prefixes = platform()->get_install_prefixes();|std::vector<std::string> install_prefixes = platform()->get_install_prefixes();\n        install_prefixes.insert(install_prefixes.begin(), (exe_dir.parent_path() / "share" / "lemonade-server").string());|' \
      src/cpp/server/utils/path_utils.cpp

    # Pre-fetched libwebsockets source is read-only in the Nix store;
    # replace the runtime -Werror patching (file READ/WRITE) with a
    # compiler flag that achieves the same result.
    sed -i '/file(READ.*libwebsockets_SOURCE_DIR.*CMakeLists.txt/,/file(WRITE.*libwebsockets_SOURCE_DIR.*CMakeLists.txt.*)/c\
    add_compile_options(-Wno-error)' CMakeLists.txt
  '';

  cmakeFlags = [
    "-DBUILD_WEB_APP=OFF"
    # Pre-fetched sources for dependencies not available via pkg-config/find_package
    "-DFETCHCONTENT_SOURCE_DIR_HTTPLIB=${cpp-httplib-src}"
    "-DFETCHCONTENT_SOURCE_DIR_LIBWEBSOCKETS=${libwebsockets-src}"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 lemond $out/bin/lemond
    install -Dm755 lemonade $out/bin/lemonade
    # Resources are looked up relative to the binary's parent directory
    mkdir -p $out/share/lemonade-server
    cp -r resources $out/share/lemonade-server/
    # Inject the pre-built web app (built outside the sandbox)
    mkdir -p $out/share/lemonade-server/resources/web-app
    cp -r ${lemonade-webapp}/. $out/share/lemonade-server/resources/web-app/
    runHook postInstall
  '';

  meta = {
    description = "Local LLM server with GPU/NPU acceleration (OpenAI-compatible API)";
    homepage = "https://github.com/lemonade-sdk/lemonade";
    license = lib.licenses.asl20;
    mainProgram = "lemonade";
    platforms = lib.platforms.linux;
  };
}
