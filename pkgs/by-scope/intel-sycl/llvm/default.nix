{
  stdenv,
  gcc,
  llvmPackages_21,
  breakpointHook,
  writeShellApplication,
  writeShellScriptBin,
  symlinkJoin,
  wrapCCWith,
  wrapBintoolsWith,
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
  vc-intrinsics,
  # boost,
  pins,
}: let
  # llvmPackages = llvmPackages_21;
  # TODO I definitely need to wrap this otherwise again cstddef file not found
  # Maybe I have to also provide symlinks to clang and clang++ so that they are wrapped ?
  # [ 89%] Linking CXX static library ../../../lib/liblldWasm.a
  # [ 89%] Built target lldWasm
  # /build/source/libdevice/imf/../imf_impl_utils.hpp:12:10: fatal error: 'cstddef' file not found
  #    12 | #include <cstddef>
  #       |          ^~~~~~~~~
  # 1 error generated.
  # make[3]: *** [tools/libdevice/CMakeFiles/imf_fallback_fp64_bc.dir/build.make:89: lib/libsycl-fallback-imf-fp64.bc] Error 1
  # make[2]: *** [CMakeFiles/Makefile2:83586: tools/libdevice/CMakeFiles/imf_fallback_fp64_bc.dir/all] Error 2
  # make[2]: *** Waiting for unfinished jobs....
  # ccWrapperStub = wrapCC (
  #   writeShellApplication {
  #     name = "clang";
  #     text = ''
  #       exec /build/source/build/bin/clang-21 "$@"
  #     '';
  #     passthru.isClang = true;
  #   }
  # );
  root = "/build/source";

  bintools = wrapBintoolsWith {
    # inherit (llvmPackages) libc;
    bintools = symlinkJoin {
      inherit version;
      pname = "bintools";

      paths = [
        (writeShellScriptBin "ar" "exec ${root}/build/bin/llvm-ar $@")
        (writeShellScriptBin "objcopy" "exec ${root}/build/bin/llvm-objcopy $@")
        (writeShellScriptBin "size" "exec ${root}/build/bin/llvm-size $@")
        (writeShellScriptBin "ld" "exec ${root}/build/bin/ld $@") # TODO not compiled yet ??

        (writeShellScriptBin "cov" "exec ${root}/build/bin/llvm-cov $@")
        (writeShellScriptBin "foreach" "exec ${root}/build/bin/llvm-foreach $@")
        (writeShellScriptBin "link" "exec ${root}/build/bin/llvm-link $@")
        (writeShellScriptBin "profdata" "exec ${root}/build/bin/llvm-profdata $@")
        (writeShellScriptBin "spirv" "exec ${root}/build/bin/llvm-spirv $@")
      ];
    };
  };

  cc = wrapCCWith {
    inherit bintools;
    # inherit (llvmPackages) libc;

    cc = writeShellApplication {
      name = "clang";
      text = ''
        exec ${root}/build/bin/clang-22 "$@"
      '';
      passthru.isClang = true;
    };

    # libc = null;

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
  # llvmPackages.libcxxStdenv.mkDerivation {
  stdenv.mkDerivation {
    inherit src version;
    pname = "intel-llvm";

    # sourceRoot = "${src.name}/llvm";

    NIX_CFLAGS_COMPILE = [
      #   "-I${llvmPackages.libcxx.dev}/include/c++/v1"
      #   "-B${llvmPackages.libcxx}/lib" # https://github.com/NixOS/nixpkgs/issues/370217
      "-Wno-unused-command-line-argument" #'-stdlib=libc++' is unused
    ];

    # # This hardening option causes compilation errors when compiling for amdgcn, spirv and others
    # # TODO: Can the cc wrapper be made aware of this somehow?
    # hardeningDisable = ["zerocallusedregs"];

    patches = [
      ./gnu-install-dirs.patch
      # ./umf.patch
      # ./xptifw.patch
      # ./install.patch # https://github.com/intel/llvm/pull/20394
      # ./emhash.patch # https://github.com/intel/llvm/commit/357f96b7e19d8acb972eb2f1fb276dbc6aa2060b
    ];

    outputs = ["out" "lib" "dev" "rsrc"];
    # setOutputFlags = false;

    nativeBuildInputs = [
      cmake
      pkg-config
      python3
      perl
      breakpointHook
    ];

    buildInputs = [
      # llvmPackages.libcxx # libcxx
      # llvmPackages.libcxx.dev # libcxx
      # stdenv.cc.cc # libgcc .lib libstdc++
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

      # sycl tests
      # "-DSYCL_INCLUDE_TESTS=OFF"
      # "-DSYCL_PI_TESTS=OFF"

      # plugins
      # "-DSYCL_BUILD_PI_HIP_PLATFORM=''"
      # "-DSYCL_BUILD_PI_ESIMD_CPU=OFF"

      # options
      "-DSYCL_ENABLE_WERROR=OFF"
      "-DSYCL_ENABLE_XPTI_TRACING=ON"
      # "-DSYCL_ENABLE_BACKENDS=opencl;level_zero;"
      # "-DSYCL_ENABLE_KERNEL_FUSION=ON"
      # "-DSYCL_ENABLE_MAJOR_RELEASE_PREVIEW_LIB=ON"

      # found in https://github.com/intel/llvm/issues/19632
      # "-DSYCL_JIT_ENABLE_WERROR=OFF"
      # "-DSYCL_LIBDEVICE_CXX_FLAGS=$NIX_CFLAGS_COMPILE"

      # Override clang resource directory to use build-time path during build
      # I am in /build/source/build/bin for whatever reason so this creates then /build/source/build/lib/clang/22
      "-DCLANG_RESOURCE_DIR=../lib/clang/22"

      # projects
      "-DLLVM_EXTERNAL_PROJECTS=sycl;sycl-jit;llvm-spirv;opencl;xpti;xptifw;libdevice"
      "-DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR=/build/source/llvm-spirv"
      "-DLLVM_EXTERNAL_XPTI_SOURCE_DIR=/build/source/xpti"
      "-DLLVM_EXTERNAL_XPTIFW_SOURCE_DIR=/build/source/xptifw"
      "-DLLVM_EXTERNAL_LIBDEVICE_SOURCE_DIR=/build/source/libdevice"
      "-DLLVM_EXTERNAL_SYCL_SOURCE_DIR=/build/source/sycl"
      "-DLLVM_EXTERNAL_SYCL_JIT_SOURCE_DIR=/build/source/sycl-jit"
      "-DLLVM_ENABLE_PROJECTS=clang;clang-tools-extra;lld;sycl;sycl-jit;llvm-spirv;opencl;xpti;xptifw;libdevice;openmp"
      # "-DLLVM_ENABLE_RUNTIMES=libc;libunwind;libcxxabi;pstl;libcxx;compiler-rt;openmp;llvm-libgcc;offload"
      # "-DLLVM_ENABLE_RUNTIMES=all"

      # sources
      "-DFETCHCONTENT_SOURCE_DIR_VC-INTRINSICS=${pins.vc-intrinsics}"
      "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=${spirv-headers}"

      # intree is used
      # "-DSYCL_UR_USE_FETCH_CONTENT=OFF"
      # "-DSYCL_UR_SOURCE_DIR=${pins.unified-runtime}"

      # /build/source/unified-runtime/source/loader/layers/sanitizer/msan/msan_libdevice.hpp:71:11: error: no type named 'size_t' i>
      #    71 | constexpr std::size_t MSAN_PRIVATE_SIZE = 0xffffffULL + 1;
      #       |           ^~~~~~~~~~~
      #       |           size_t
      # "-DUR_ENABLE_SANITIZER=OFF"
      # "-DUR_ENABLE_SYMBOLIZER=OFF"

      # TODO vielleicht pins.compute-runtime headers mit einem richtigen package ersetzen ?
      "-DUR_USE_EXTERNAL_UMF=ON"
      "-DL0_COMPUTE_RUNTIME_HEADERS=${pins.compute-runtime}/level_zero/include"

      # "-DUR_OPENCL_INCLUDE_DIR=${opencl-headers}/include/CL"
      # "-DUR_LEVEL_ZERO_LOADER_LIBRARY=${level-zero}/lib/libze_loader.so"
      # "-DUR_LEVEL_ZERO_INCLUDE_DIR=${level-zero}/include"

      # "-DLEVEL_ZERO_INCLUDE_DIR=${level-zero}/include/level_zero"
      # "-DLEVEL_ZERO_LIBRARY=${level-zero}/lib/libze_loader.so"

      # "-DOpenCL_HEADERS=${pins.ocl-headers}"
      # "-DOpenCL_LIBRARY_SRC=${pins.ocl-loader}"
      # "-DOpenCL-ICD=${ocl-icd}/lib/libOpenCL.so"

      # "-DBOOST_MP11_SOURCE_DIR=${pins.mp11}"
      # "-DBOOST_MODULE_SRC_DIR=${boost.dev}"

      # "-DSYCL_EMHASH_DIR=${pins.emhash}"
      # "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
      # "-DFETCHCONTENT_SOURCE_DIR_PARALLEL_HASHMAP=${pins.parallel-hashmap}"
      # "-DXPTIFW_PARALLEL_HASHMAP_HEADERS=${pins.parallel-hashmap}"
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

    # preConfigure = ''
    #   cd llvm
    # '';

    # fixed by install.patch
    # # https://github.com/intel/llvm/issues/6937
    # buildPhase = ''
    #   cmake --build /build/source/llvm/build --parallel $NIX_BUILD_CORES --target=deploy-sycl-toolchain
    # '';

    # dontMoveToDev = true;

    # postInstall = ''
    #   mkdir -p $rsrc
    #   mv $out/lib/clang/21/include $rsrc/include
    #   rm -r $out/lib/clang

    #   mkdir -p $dev
    #   mv $out/include $dev/include
    #   # mv $out/lib/cmake $dev/lib/cmake
    #   # mv $out/share/pkgconfig $dev/share/pkgconfig

    #   mkdir -p $lib
    #   mv $out/lib $lib/lib
    # '';

    postInstall = ''
      # If this stays in $out/bin, it'll create a circular reference
      moveToOutput "bin/llvm-config*" "$dev"
    '';

    postFixup = ''
      mkdir -p $rsrc
      mv $out/lib/clang/22/include $rsrc/include
    '';

    passthru.isLLVM = true;
    passthru.isClang = true;
  }
