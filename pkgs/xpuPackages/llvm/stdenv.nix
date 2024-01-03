{
  llvmPackages,
  overrideCC,
  toolchain,
}:
overrideCC llvmPackages.libcxxStdenv toolchain
