{
  lib,
  cmake,
  fetchFromGitHub,
  dpcppStdenv,
  intel-dpcpp,
  intel-mkl,
  blas,
  pkg-config,
  ninja,
  git,
  autoAddDriverRunpath,
}: let
  inherit (lib) cmakeBool cmakeFeature;
in
  dpcppStdenv.mkDerivation (finalAttrs: {
    pname = "llama-cpp";
    version = "3089";

    src = fetchFromGitHub {
      owner = "ggerganov";
      repo = "llama.cpp";
      rev = "refs/tags/b${finalAttrs.version}";
      hash = "sha256-bI1qSO0f+Uf7svcxAKt1g8fEXjJlMcJWO6zhMkjDGPA=";
      leaveDotGit = true;
      postFetch = ''
        git -C "$out" rev-parse --short HEAD > $out/COMMIT
        find "$out" -name .git -print0 | xargs -0 rm -rf
      '';
    };

    postPatch = ''
      substituteInPlace ./scripts/build-info.cmake \
        --replace-fail 'set(BUILD_NUMBER 0)' 'set(BUILD_NUMBER ${finalAttrs.version})' \
        --replace-fail 'set(BUILD_COMMIT "unknown")' "set(BUILD_COMMIT \"$(cat COMMIT)\")"
    '';

    nativeBuildInputs = [
      cmake
      ninja
      pkg-config
      git
      autoAddDriverRunpath
    ];

    buildInputs = [
      blas
      intel-mkl
    ];

    cmakeFlags = [
      # -march=native is non-deterministic; override with platform-specific flags if needed
      (cmakeBool "LLAMA_NATIVE" true)
      (cmakeBool "BUILD_SHARED_SERVER" true)
      (cmakeBool "BUILD_SHARED_LIBS" true)
      (cmakeBool "LLAMA_BLAS" true)
      (cmakeBool "LLAMA_SYCL" true)
      (cmakeBool "LLAMA_SYCL_F16" true)
      (cmakeFeature "CMAKE_C_COMPILER" "icx")
      (cmakeFeature "CMAKE_CXX_COMPILER" "icpx")
      (cmakeFeature "OpenMP_CXX_FLAGS" "-qopenmp")
      (cmakeFeature "OpenMP_CXX_LIB_NAMES" "libiomp5")
      (cmakeFeature "OpenMP_C_FLAGS" "-qopenmp")
      (cmakeFeature "OpenMP_C_LIB_NAMES" "libiomp5")
      (cmakeFeature "OpenMP_libiomp5_LIBRARY" "${intel-dpcpp.runtime}/lib/libiomp5.so")
      "-DSYCL_INCLUDE_DIR=${intel-dpcpp.runtime}/include"
      "-DSYCL_LIBRARY_DIR=${intel-dpcpp.runtime}/lib"
    ];

    # upstream plans on adding targets at the cmakelevel, remove those
    # additional steps after that
    postInstall = ''
      mv $out/bin/main $out/bin/llama
      mv $out/bin/server $out/bin/llama-server
      mkdir -p $out/include
      cp $src/llama.h $out/include/
    '';

    meta = with lib; {
      description = "Port of Facebook's LLaMA model in C/C++";
      homepage = "https://github.com/ggerganov/llama.cpp/";
      license = licenses.mit;
      mainProgram = "llama";
      maintainers = with maintainers; [mordrag];
      platforms = platforms.unix;
    };
  })
