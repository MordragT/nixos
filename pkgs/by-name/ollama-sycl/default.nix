{
  lib,
  buildGo122Module,
  fetchFromGitHub,
  fetchpatch,
  stdenv,
  makeWrapper,
  autoAddDriverRunpath,
  addDriverRunpath,
  cmake,
  ninja,
  pkg-config,
  ocl-icd,
  blas,
  intel-dpcpp,
  intel-mkl,
  intel-tbb,
  acceleration ? null,
}: let
  inherit (lib) cmakeBool cmakeFeature;
  version = "0.3.10";
  src = fetchFromGitHub {
    owner = "ollama";
    repo = "ollama";
    rev = "v${version}";
    hash = "sha256-iNjqnhiM0L873BiBPAgI2Y0KEQyCInn2nEihzwLasFU=";
    fetchSubmodules = true;
  };

  preparePatch = patch: hash:
    fetchpatch {
      url = "file://${src}/llm/patches/${patch}";
      inherit hash;
    };
  llamaCppPatches = [
    (preparePatch "01-load-progress.diff" "sha256-iN4DfZjuAuSKT4MdKwoGak431yUFSQ9dz9FlPI6B1K8=")
    (preparePatch "02-clip-log.diff" "sha256-dabeuEr8+xq9NTi5FTtG7MqHa9LWMrOnshFTYkPYF4Q=")
    (preparePatch "03-load_exception.diff" "sha256-0S99aNLj59ljFtCuG+9Wbgp3Sv0fZy1YFfA/XA9J1nE=")
    (preparePatch "04-metal.diff" "sha256-l97rYGo8YFKw64bJ3TaJeXOtArKZ25wQp1ElplK/Yho=")
    (preparePatch "05-default-pretokenizer.diff" "sha256-J998wePQmOLHsmwfPgDlqKa9p6Sg4HXVDSfuptSpZL0=")
    (preparePatch "06-embeddings.diff" "sha256-Ru/0Yt4Zm+e7H2s/Ygykq13p1WXe2EMfbZJ14gSiZ8c=")
    (preparePatch "07-clip-unicode.diff" "sha256-JWzOcJPf9opg4C4eNOhpZYHbpgkoIsxtE4DN+t6wf6U=")
  ];

  llama-cpp-static = stdenv.mkDerivation {
    pname = "ollama-cpp-static";
    inherit version src;

    sourceRoot = "source/llm/llama.cpp";

    nativeBuildInputs = [
      cmake
      ninja
    ];

    patches = llamaCppPatches;

    cmakeFlags = [
      # -march=native is non-deterministic; override with platform-specific flags if needed
      (cmakeBool "GGML_NATIVE" true)
      (cmakeBool "BUILD_SHARED_LIBS" false)
      (cmakeBool "GGML_OPENMP" false)
    ];

    prePatch = ''
      echo 'add_subdirectory(../ext_server ext_server) # ollama' >> CMakeLists.txt
    '';
  };
  llama-cpp-sycl = intel-dpcpp.stdenv.mkDerivation {
    pname = "ollama-cpp-sycl";
    inherit version src;

    sourceRoot = "source/llm/llama.cpp";

    nativeBuildInputs = [
      autoAddDriverRunpath
      cmake
      ninja
      pkg-config
    ];

    buildInputs = [
      intel-mkl
      intel-tbb
      ocl-icd
      blas
    ];

    patches = llamaCppPatches;

    cmakeFlags = [
      # -march=native is non-deterministic; override with platform-specific flags if needed
      (cmakeBool "GGML_NATIVE" true)
      (cmakeBool "BUILD_SHARED_LIBS" true)
      (cmakeBool "GGML_BLAS" true)
      (cmakeBool "GGML_SYCL" true)
      (cmakeBool "GGML_SYCL_F16" false)
      (cmakeFeature "CMAKE_C_COMPILER" "icx")
      (cmakeFeature "CMAKE_CXX_COMPILER" "icpx")
    ];

    prePatch = ''
      echo 'add_subdirectory(../ext_server ext_server) # ollama' >> CMakeLists.txt
    '';
  };
in
  buildGo122Module {
    pname = "ollama";
    inherit version src;

    vendorHash = "sha256-hSxcREAujhvzHVNwnRTfhi0MKI3s8HNavER2VLz6SYk=";

    nativeBuildInputs = [
      makeWrapper
    ];

    buildInputs = [
      llama-cpp-static
    ];

    propagatedBuildInputs = [
      llama-cpp-sycl
    ];

    doCheck = false;

    ldflags = [
      "-s"
      "-w"
      "-X=github.com/ollama/ollama/version.Version=${version}"
      "-X=github.com/ollama/ollama/server.mode=release"
    ];

    postPatch = ''
      # replace inaccurate version number with actual release version
      substituteInPlace version/version.go --replace-fail 0.0.0 '${version}'

      substituteInPlace gpu/gpu_oneapi.go \
        --replace-fail '"ONEAPI_DEVICE_SELECTOR", "level_zero:" + strings.Join(ids, ",")' '"ONEAPI_DEVICE_SELECTOR", "opencl:*"' \
        --replace-fail '"strings"' ""
    '';

    preBuild = ''
      mkdir -p llm/build/linux/x86_64/oneapi/bin

      makeWrapper ${llama-cpp-sycl}/bin/ollama_llama_server llm/build/linux/x86_64/oneapi/bin/ollama_llama_server \
        --set ZES_ENABLE_SYSMAN '1'

      gzip -n --force --best llm/build/linux/x86_64/oneapi/bin/ollama_llama_server
    '';

    postFixup = ''
      # expose runtime libraries necessary to use the gpu
      wrapProgram "$out/bin/ollama" \
        --suffix LD_LIBRARY_PATH : '${addDriverRunpath.driverLink}/lib'
    '';

    meta = {
      description = "Get up and running with large language models locally";
      homepage = "https://github.com/ollama/ollama";
      changelog = "https://github.com/ollama/ollama/releases/tag/v${version}";
      license = lib.licenses.mit;
      platforms = lib.platforms.unix;
      mainProgram = "ollama";
      maintainers = with lib.maintainers; [mordrag];
    };
  }
