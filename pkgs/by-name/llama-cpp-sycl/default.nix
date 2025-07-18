{
  lib,
  cmake,
  fetchFromGitHub,
  intel-sycl,
  intel-mkl,
  oneapi-tbb,
  oneapi-dnn,
  level-zero,
  ocl-icd,
  opencl-headers,
  blas,
  pkg-config,
  ninja,
  git,
  autoAddDriverRunpath,
}: let
  inherit (lib) cmakeBool;
in
  intel-sycl.stdenv.mkDerivation (finalAttrs: {
    pname = "llama-cpp";
    version = "5898";

    src = fetchFromGitHub {
      owner = "ggerganov";
      repo = "llama.cpp";
      rev = "refs/tags/b${finalAttrs.version}";
      hash = "";
      leaveDotGit = true;
      postFetch = ''
        git -C "$out" rev-parse --short HEAD > $out/COMMIT
        find "$out" -name .git -print0 | xargs -0 rm -rf
      '';
    };

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
      oneapi-tbb
      oneapi-dnn
      level-zero
      ocl-icd
      opencl-headers
    ];

    cmakeFlags = [
      # -march=native is non-deterministic; override with platform-specific flags if needed
      (cmakeBool "GGML_NATIVE" true)
      (cmakeBool "LLAMA_BUILD_SERVER" true)
      (cmakeBool "BUILD_SHARED_LIBS" true)
      (cmakeBool "GGML_BLAS" true)
      (cmakeBool "GGML_SYCL" true)
      (cmakeBool "GGML_SYCL_F16" true)
      # (cmakeFeature "CMAKE_C_COMPILER" "icx")
      # (cmakeFeature "CMAKE_CXX_COMPILER" "icpx")
    ];

    postPatch = ''
      substituteInPlace ./scripts/build-info.sh \
        --replace-fail 'build_number="0"' 'build_number="${finalAttrs.version}"' \
        --replace-fail 'build_commit="unknown"' "build_commit=\"$(cat COMMIT)\""
    '';

    # upstream plans on adding targets at the cmakelevel, remove those
    # additional steps after that
    postInstall = ''
      # Match previous binary name for this package
      ln -sf $out/bin/llama-cli $out/bin/llama

      mkdir -p $out/include
      cp $src/include/llama.h $out/include/
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
