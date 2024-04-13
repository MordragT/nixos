{
  wrapBintoolsWith,
  wrapCCWith,
  glibc,
  llvm,
  compiler-rt,
  pstl,
  libcxx,
  libdevice,
}:
# not working: openmp libc;
wrapCCWith {
  inherit libcxx;
  # inherit libc;
  libc = glibc;
  cc = llvm;
  bintools = wrapBintoolsWith {
    libc = glibc;
    bintools = llvm;
  };
  extraPackages = [
    compiler-rt
    pstl
    libdevice
    # openmp
  ];
}
