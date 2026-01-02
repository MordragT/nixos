{
  stdenv,
  gcc,
  breakpointHook,
  writeShellApplication,
  wrapCCWith,
  src,
  version,
  cmake,
  pkg-config,
  python3,
  perl,
  libz,
  libxml2,
  ncurses,
  hwloc,
  level-zero,
  unified-memory-framework,
  emhash,
  parallel-hashmap,
  spirv-headers,
  opencl-headers,
  ocl-icd,
  intel-compute-runtime,
  # vc-intrinsics,
  pins,
}: let
  root = "/build/source";
  cc = wrapCCWith {
    cc = writeShellApplication {
      name = "clang";
      text = ''
        exec ${root}/build/bin/clang-22 "$@"
      '';
      passthru.isClang = true;
    };

    extraBuildCommands = ''
      # Disable hardening by default because of `zerocallusedregs`
      # This hardening option causes compilation errors when compiling for amdgcn, spirv and others
      echo "" > $out/nix-support/add-hardening.sh
    '';

    nixSupport = {
      cc-cflags = [
        "-isystem /build/source/build/include"
        "-resource-dir=/build/source/build/lib/clang/22"
        "--gcc-toolchain=${gcc.cc}"
      ];

      cc-ldflags = [
        "-L/build/source/build/lib"
        "-L${gcc.cc}/lib/gcc/${stdenv.targetPlatform.config}/${gcc.version}"
        "-L${gcc.cc.lib}/lib"
      ];
    };
  };
in
  stdenv.mkDerivation {
    inherit src version;
    pname = "intel-llvm";

    NIX_CFLAGS_COMPILE = [
      "-Wno-unused-command-line-argument" #'-stdlib=libc++' is unused
    ];

    # This hardening option causes compilation errors when compiling for amdgcn, spirv and others
    # Fixed by cc-wrapper
    # hardeningDisable = ["zerocallusedregs"];

    patches = [
      ./gnu-install-dirs.patch
    ];

    outputs = ["out" "lib" "dev" "rsrc" "python"];

    nativeBuildInputs = [
      cmake
      pkg-config
      python3
      perl
      breakpointHook
    ];

    buildInputs = [
      libz
      libxml2
      ncurses
      hwloc
      unified-memory-framework
      emhash
      parallel-hashmap
      level-zero
      opencl-headers
      ocl-icd
      # vc-intrinsics
    ];

    cmakeBuildType = "Release";
    cmakeDir = "../llvm";

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DLLVM_TARGETS_TO_BUILD=Native"
      "-DLLVM_INSTALL_UTILS=ON"
      "-DLLVM_ENABLE_ZSTD=ON"
      "-DLLVM_USE_STATIC_ZSTD=ON"

      "-DLLVM_INSTALL_PACKAGE_DIR=${placeholder "dev"}/lib/cmake/llvm"

      # # libcxx
      # "-DLLVM_ENABLE_LIBCXX=ON"
      # "-DSYCL_USE_LIBCXX=ON"
      # "-DSYCL_LIBCXX_INCLUDE_PATH=${llvmPackages.libcxx.dev}/include/c++/v1"
      # "-DSYCL_LIBCXX_LIBRARY_PATH=${llvmPackages.libcxx}/lib"

      # tests
      "-DLLVM_INCLUDE_TESTS=OFF"
      "-DLLVM_BUILD_TESTS=OFF"
      "-DLLVM_ENABLE_ASSERTIONS=OFF"

      # docs
      "-DLLVM_ENABLE_DOXYGEN=OFF"
      "-DLLVM_ENABLE_SPHINX=OFF"

      # projects
      "-DLLVM_EXTERNAL_PROJECTS=sycl;sycl-jit;llvm-spirv;opencl;xpti;xptifw;libdevice"
      "-DLLVM_EXTERNAL_SYCL_SOURCE_DIR=/build/source/sycl"
      "-DLLVM_EXTERNAL_SYCL_JIT_SOURCE_DIR=/build/source/sycl-jit"
      "-DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR=/build/source/llvm-spirv"
      "-DLLVM_EXTERNAL_XPTI_SOURCE_DIR=/build/source/xpti"
      "-DLLVM_EXTERNAL_XPTIFW_SOURCE_DIR=/build/source/xptifw"
      "-DLLVM_EXTERNAL_LIBDEVICE_SOURCE_DIR=/build/source/libdevice"
      "-DLLVM_ENABLE_PROJECTS=clang;clang-tools-extra;sycl;sycl-jit;llvm-spirv;opencl;xpti;xptifw;libdevice"

      # options
      "-DSYCL_ENABLE_XPTI_TRACING=ON"
      "-DSYCL_COMPILER_VERSION=20251112" # TODO find a better way to set this

      # Override clang resource directory to use build-time path during build to match cc-wrapper
      "-DCLANG_RESOURCE_DIR=../lib/clang/22"

      # sources
      "-DFETCHCONTENT_SOURCE_DIR_VC-INTRINSICS=${pins.vc-intrinsics}"
      "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=${spirv-headers}"

      # TODO vielleicht pins.compute-runtime headers mit einem richtigen package ersetzen ?
      "-DUR_USE_EXTERNAL_UMF=ON"
      "-DL0_COMPUTE_RUNTIME_HEADERS=${intel-compute-runtime.src}/level_zero/include"
    ];

    postPatch = ''
      # Parts of libdevice are built using the freshly-built compiler.
      # As it tries to link to system libraries, we need to wrap it with the
      # usual nix cc-wrapper.
      # Since the compiler to be wrapped is not available at this point,
      # we use a stub that points to where it will be later on
      # in `/build/source/build/bin/clang-22`
      # Note: both nix and bash try to expand clang_exe here, so double-escape it
      substituteInPlace libdevice/cmake/modules/SYCLLibdevice.cmake \
        --replace-fail "\''${clang_exe}" "${cc}/bin/clang"

      # `NO_CMAKE_PACKAGE_REGISTRY` prevents it from finding OpenCL, so we unset it
      substituteInPlace unified-runtime/cmake/FetchOpenCL.cmake \
        --replace-fail "NO_CMAKE_PACKAGE_REGISTRY" ""
    '';

    postInstall = ''
      mkdir -p $python/share
      mv $out/share/opt-viewer $python/share/opt-viewer

      # If this stays in $out/bin, it'll create a circular reference
      moveToOutput "bin/llvm-config*" "$dev"

      substituteInPlace "$dev/lib/cmake/llvm/LLVMExports-release.cmake" \
        --replace-fail "$out/bin/llvm-config" "$dev/bin/llvm-config"

      substituteInPlace "$dev/lib/cmake/llvm/LLVMExports.cmake" \
        --replace-fail "\''${_IMPORT_PREFIX}/include" "$dev/include"

      substituteInPlace "$dev/lib/cmake/llvm/LLVMConfig.cmake" \
        --replace-fail 'set(LLVM_BINARY_DIR "''${LLVM_INSTALL_PREFIX}")' 'set(LLVM_BINARY_DIR "'"$lib"'")'
    '';

    postFixup = ''
      mkdir -p $rsrc
      mv $out/lib/clang/22/include $rsrc/include
      rm -rf $out/lib/clang
    '';

    passthru.isLLVM = true;
    passthru.isClang = true;
  }
