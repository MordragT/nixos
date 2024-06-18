{
  useMoldLinker,
  withCFlags,
  llvmPackages,
}:
withCFlags [
  # "-flto" # link time optimization
  "-march=x86-64-v3"
  "-O3"
]
(
  useMoldLinker
  llvmPackages.libcxxStdenv
)
