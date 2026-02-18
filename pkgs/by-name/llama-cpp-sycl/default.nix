{
  lib,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  intel-sycl,
  oneapi-tbb,
  oneapi-dnn,
  oneapi-math,
  level-zero,
  ocl-icd,
  opencl-headers,
  curl,
  pkg-config,
  ninja,
  git,
  autoAddDriverRunpath,
}: let
  inherit (lib) cmakeBool;
in
  intel-sycl.stdenv.mkDerivation (finalAttrs: {
    pname = "llama-cpp";
    version = "7610";

    src = fetchFromGitHub {
      owner = "ggerganov";
      repo = "llama.cpp";
      rev = "refs/tags/b${finalAttrs.version}";
      hash = "sha256-GJadIF4QyXsKUs2JgYj7RWFnDERcxfNxOyrFoB+51u8=";
      leaveDotGit = true;
      postFetch = ''
        git -C "$out" rev-parse --short HEAD > $out/COMMIT
        find "$out" -name .git -print0 | xargs -0 rm -rf
      '';
    };

    patches = [
      # sycl: Use oneMath on non-WIN32
      (fetchpatch {
        url = "https://patch-diff.githubusercontent.com/raw/ggml-org/llama.cpp/pull/13503.patch";
        hash = "sha256-3UU4nrOnJVVz8TLdtsfg/zLub37Y73IyhBRUqD547iA=";
      })
      ./remove-syclcompat.patch
    ];

    nativeBuildInputs = [
      cmake
      ninja
      pkg-config
      git
      autoAddDriverRunpath
    ];

    buildInputs = [
      oneapi-tbb
      oneapi-dnn
      oneapi-math
      level-zero
      ocl-icd
      opencl-headers
      curl
    ];

    cmakeFlags = [
      (cmakeBool "GGML_NATIVE" true)
      (cmakeBool "LLAMA_BUILD_SERVER" true)
      (cmakeBool "BUILD_SHARED_LIBS" true)
      (cmakeBool "GGML_SYCL" true)
      (cmakeBool "GGML_SYCL_DNNL" true)
      (cmakeBool "GGML_SYCL_F16" true)
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
