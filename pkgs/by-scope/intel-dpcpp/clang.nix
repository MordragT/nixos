{
  wrapCCWith,
  symlinkJoin,
  stdenv,
  llvm,
  intel-tcm,
  hwloc,
  bintools,
  gcc13,
}: let
  gcc = gcc13;
  cc = symlinkJoin {
    name = "clang-unwrapped";
    paths = [llvm llvm.dev llvm.lib intel-tcm hwloc];
  };
in
  (wrapCCWith {
    inherit cc bintools;
    extraBuildCommands = ''
      wrap icx $wrapper $ccPath/icx
      wrap icpx $wrapper $ccPath/icpx
      wrap dpcpp $wrapper $ccPath/dpcpp

      # Disable hardening by default
      echo "" > $out/nix-support/add-hardening.sh
    '';

    nixSupport = {
      cc-cflags = [
        "-isystem ${cc}/include"
        "-isystem ${cc}/include/sycl"
        "-resource-dir=${llvm.rsrc}"
        "--gcc-toolchain=${gcc.cc}"
      ];

      cc-ldflags = [
        "-L${cc}/lib"
        "-L${gcc.cc}/lib/gcc/${stdenv.targetPlatform.config}/${gcc.version}"
        "-L${gcc.cc.lib}/lib"
      ];

      setup-hook = [
        "export ONEAPI_ROOT=${cc}"
        "export CMPLR_ROOT=${cc}"
        "export SYCL_INCLUDE_DIR_HINT=${cc}"
        "export SYCL_LIBRARY_DIR_HINT=${cc}"
      ];
    };
  })
  .overrideAttrs (old: {
    installPhase =
      old.installPhase
      + ''
        export named_cc="icx"
        export named_cxx="icpx"
      '';
  })
