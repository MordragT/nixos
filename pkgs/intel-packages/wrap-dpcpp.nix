{
  dpcpp-unwrapped,
  wrapCCWith,
  gcc,
  stdenv,
}: let
  cc = dpcpp-unwrapped;
in
  (wrapCCWith {
    inherit cc;
    extraBuildCommands = ''
      wrap icx $wrapper $ccPath/icx
      wrap icpx $wrapper $ccPath/icpx
      wrap dpcpp $wrapper $ccPath/dpcpp

      echo "-isystem ${cc}/include" >> $out/nix-support/cc-cflags
      echo "--gcc-toolchain=${gcc.cc}" >> $out/nix-support/cc-cflags

      echo "-L${cc}/lib" >> $out/nix-support/cc-ldflags
      echo "-L${gcc.cc}/lib/gcc/${stdenv.targetPlatform.config}/${gcc.version}" >> $out/nix-support/cc-ldflags
      echo "-L${gcc.cc.lib}/lib" >> $out/nix-support/cc-ldflags

      # Disable hardening by default
      echo "" > $out/nix-support/add-hardening.sh
    '';

    extraPackages = [cc];
  })
  .overrideAttrs (old: {
    installPhase =
      old.installPhase
      + ''
        export named_cc="icx"
        export named_cxx="icpx"
      '';
  })
