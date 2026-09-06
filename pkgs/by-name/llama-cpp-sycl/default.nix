{
  lib,
  cmake,
  fetchFromGitHub,
  fetchNpmDeps,
  intel-llvm,
  intel-compute-runtime,
  intel-graphics-compiler,
  oneapi-tbb,
  oneapi-dnn,
  oneapi-mkl,
  level-zero,
  ocl-icd,
  opencl-headers,
  curl,
  pkg-config,
  ninja,
  nodejs,
  npmHooks,
  autoAddDriverRunpath,
}:
let
  inherit (lib) cmakeBool cmakeFeature;

  # Upstream reads these from git, which the release tarball does not ship.
  # They are purely informational: `llama-server --version`, `/props`, and the web UI.
  buildNumber = "10809";
  buildCommit = "5266f24";
in
intel-llvm.stdenv.mkDerivation (finalAttrs: {
  pname = "llama-cpp";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ggerganov";
    repo = "llama.cpp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WImZjO3U9EXZUNP/FMpxo8PaTjQW8X2SBTfGwwFlZIM=";
  };

  patches = [
    ./remove-trsm-batch.patch
  ];

  # nixpkgs' default `_FORTIFY_SOURCE=2/3` makes Clang emit `__memcpy_chk`
  # (the bounds-checked memcpy) instead of plain `__memcpy`. The Intel
  # Graphics Compiler (IGC) shipping in `intel-compute-runtime` does not
  # implement `__memcpy_chk` in its device-side runtime, so the JIT step
  # fails at first kernel dispatch.
  hardeningDisable = [ "all" ];

  # Disable automatic stripping completely
  dontStrip = true;

  env = {
    # libigc missing problems for ocloc (compute runtime)
    LD_LIBRARY_PATH = "${intel-graphics-compiler}/lib";
    NIX_CFLAGS_COMPILE = "-Xdevice-post-link --device-lib-dir=${intel-llvm.unwrapped.lib}/lib/dpcpp-7/sycl";
  };

  nativeBuildInputs = [
    autoAddDriverRunpath
    intel-compute-runtime
    intel-graphics-compiler
    cmake
    ninja
    pkg-config
    nodejs
    npmHooks.npmConfigHook
  ];

  buildInputs = [
    oneapi-tbb
    oneapi-dnn
    oneapi-mkl
    level-zero
    ocl-icd
    opencl-headers
    curl
  ];

  cmakeFlags = [
    (cmakeFeature "CMAKE_CXX_FLAGS" "-w")
    (cmakeBool "GGML_NATIVE" false)
    (cmakeBool "LLAMA_BUILD_EXAMPLES" false)
    (cmakeBool "LLAMA_BUILD_SERVER" true)
    (cmakeBool "LLAMA_OPENSSL" true)
    (cmakeBool "BUILD_SHARED_LIBS" false)
    (cmakeBool "GGML_SYCL" true)
    (cmakeBool "GGML_SYCL_DNNL" true)
    (cmakeBool "GGML_SYCL_F16" true)
    (cmakeBool "GGML_SYCL_HOST_MEM_FALLBACK" true)
    # (cmakeFeature "GGML_SYCL_DEVICE_ARCH" "dg2-g10")
    (cmakeFeature "LLAMA_BUILD_NUMBER" buildNumber)
    (cmakeFeature "LLAMA_BUILD_COMMIT" buildCommit)
  ];

  npmRoot = "tools/ui";
  npmDepsHash = "sha256-2Q7XhaLAArmviOLdQsNbYTfdyDE5pW9lR26cRHEVl9k=";
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
