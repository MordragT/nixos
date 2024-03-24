{
  wrapBintoolsWith,
  wrapCCWith,
  glibc,
  llvm,
  compiler-rt,
  pstl,
  libcxx,
}:
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
    # openmp
  ];
}
