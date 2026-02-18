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

  extraPackages = [
    llvm.dev
    llvm.lib
  ];

  nixSupport = {
    cc-cflags = [
      "-isystem ${llvm.dev}/include"
      "-isystem ${llvm.dev}/include/sycl"
      "-resource-dir=${llvm.rsrc}"
      "--gcc-toolchain=${gcc.cc}"
    ];

    cc-ldflags = [
      "-L${llvm.lib}/lib"
      "-L${gcc.cc}/lib/gcc/${stdenv.targetPlatform.config}/${gcc.version}"
      "-L${gcc.cc.lib}/lib"
    ];
  };
})
