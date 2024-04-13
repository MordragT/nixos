{
  # spirv-llvm-translator,
  llvm,
  envNoLibs,
  fetchFromGitHub,
  callPackage,
}: let
  # spirv = spirv-llvm-translator.override {
  #   inherit llvm;
  # };
  vc-intrinsics-git = fetchFromGitHub {
    owner = "intel";
    repo = "vc-intrinsics";
    rev = "da892e1982b6c25b9a133f85b4ac97142d8a3def";
    hash = "sha256-d197m80vSICdv4VKnyqdy3flzbKLKmB8jroY2difA7o=";
  };
in
  callPackage ./base.nix rec {
    stdenv = envNoLibs;

    name = "libdevice";
    targetDir = name;

    cmakeFlags = [
      # "-DCMAKE_MINIMUM_REQUIRED=VERSION_3.28"
      "-DCMAKE_POLICY_DEFAULT_CMP0057=NEW"
      "-DLLVM_TARGETS_TO_BUILD=X86"
      "-DLLVM_EXTERNAL_PROJECTS=${name}"
      "-DLLVMGenXIntrinsics_SOURCE_DIR=${vc-intrinsics-git}"
    ];

    extraBuildInputs = [
      # spirv
      llvm
    ];
  }
