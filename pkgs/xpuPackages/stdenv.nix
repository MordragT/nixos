{
  llvmPackages_17,
  xpuPackages,
}:
llvmPackages_17.libcxxStdenv.override {
  cc = xpuPackages.dpcpp-cpp;
}
