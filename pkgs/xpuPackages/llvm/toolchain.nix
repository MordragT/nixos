{
  cc,
  llvmPackages,
  wrapCCWith,
  # wrapBintoolsWith,
}:
wrapCCWith {
  inherit (llvmPackages) bintools libcxx;
  inherit cc;
  extraPackages = with llvmPackages; [
    libcxxabi
  ];
}
