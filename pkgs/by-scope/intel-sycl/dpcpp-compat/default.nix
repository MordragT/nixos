{
  buildEnv,
  llvm,
  clang,
  gcc,
  ocl-icd,
  opencl-headers,
  level-zero,
  openmp,
  pti-gpu,
}: let
  paths = [
    llvm.out
    llvm.dev
    llvm.lib
    level-zero
    ocl-icd
    opencl-headers
    openmp.out
    openmp.dev
    pti-gpu.sdk
  ];
  root = buildEnv {
    name = "dpcpp-compat-env";

    inherit paths;

    postBuild = ''
      ln -s $out/bin/clang $out/bin/dpcpp
      ln -s $out/bin/clang $out/bin/icx
      ln -s $out/bin/clang++ $out/bin/icpx

      mkdir -p $out/lib/clang/22
      ln -s "${llvm.rsrc}/include" $out/lib/clang/22/include
    '';
  };
in
  clang.overrideAttrs (old: {
    # propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ paths;
    propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ [root];

    installPhase =
      old.installPhase
      + ''
        echo "export SYCL_ROOT=${root}" >> $out/nix-support/setup-hook
        echo "export CMPLR_ROOT=${root}" >> $out/nix-support/setup-hook
      '';
  })
# let
# dpcpp = runCommand "intel-sycl-dpcpp-compat" {preferLocalBuild = true;} ''
#   mkdir -p $out/bin
#   ln -s ${llvm}/bin/clang $out/bin/dpcpp
#   ln -s ${llvm}/bin/clang $out/bin/icx
#   ln -s ${llvm}/bin/clang++ $out/bin/icpx
# '';
# cc = symlinkJoin {
#   name = "clang-unwrapped";
#   paths = [
#     llvm
#     llvm.dev
#     llvm.lib
#     dpcpp
#     ocl-icd
#     opencl-headers
#     level-zero
#   ];
# };
# cc = llvm;
# in (wrapCCWith {
#   inherit cc bintools;
#   extraBuildCommands = ''
#     # Disable hardening by default
#     echo "" > $out/nix-support/add-hardening.sh
#     wrap dpcpp $wrapper $ccPath/clang
#     wrap icx $wrapper $ccPath/clang
#     wrap icpx $wrapper $ccPath/clang++
#   '';
#   extraPackages = [
#     llvm.dev
#     llvm.lib
#     ocl-icd
#     opencl-headers
#     level-zero
#   ];
#   nixSupport = {
#     cc-cflags = [
#       "-isystem ${llvm.dev}/include"
#       "-isystem ${llvm.dev}/include/sycl"
#       "-resource-dir=${llvm.rsrc}"
#       "--gcc-toolchain=${gcc.cc}"
#     ];
#     cc-ldflags = [
#       "-L${llvm.lib}/lib"
#       "-L${gcc.cc}/lib/gcc/${stdenv.targetPlatform.config}/${gcc.version}"
#       "-L${gcc.cc.lib}/lib"
#     ];
#     setup-hook = [
#       "export CMPLR_ROOT=$out"
#       "export SYCL_ROOT=$out"
#     ];
#   };
# })
# .overrideAttrs (old: {
#   installPhase =
#     old.installPhase
#     + ''
#       ln -s $out/bin/clang $out/bin/dpcpp
#       ln -s $out/bin/clang $out/bin/icx
#       ln -s $out/bin/clang++ $out/bin/icpx
#     '';
# })

