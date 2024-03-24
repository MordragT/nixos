{
  src,
  version,
  runtime,
  pname ? runtime,
  llvm,
  wrapCC,
  overrideCC,
  clangStdenvNoLibs,
  python3,
  cmake,
  perl,
}: let
  cc = wrapCC llvm;
  env = overrideCC clangStdenvNoLibs cc;
in
  env.mkDerivation {
    inherit pname src version;

    nativeBuildInputs = [
      cmake
      python3
      perl
    ];

    cmakeFlags = [
      "-DLLVM_ENABLE_RUNTIMES=${runtime}"
    ];

    prePatch = ''
      cd runtimes
    '';
  }
