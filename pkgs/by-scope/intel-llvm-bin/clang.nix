{
  wrapCCWith,
  llvm,
  bintools,
  gcc,
  stdenv,
}: let
  cc = llvm;
in (wrapCCWith {
  inherit cc bintools;
  extraBuildCommands = ''
    # Disable hardening by default
    echo "" > $out/nix-support/add-hardening.sh
  '';

  nixSupport = {
    cc-cflags = [
      "-isystem ${llvm.dev}/include"
      "--gcc-toolchain=${gcc.cc}"
    ];

    cc-ldflags = [
      "-L${llvm.lib}/lib"
      "-L${gcc.cc}/lib/gcc/${stdenv.targetPlatform.config}/${gcc.version}"
      "-L${gcc.cc.lib}/lib"
    ];

    setup-hook = [
      "export ONEAPI_ROOT=${cc}"
      "export CMPLR_ROOT=${cc}"
    ];
  };
})
