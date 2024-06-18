{
  wrapCCWith,
  wrapBintoolsWith,
  compiler-rt,
  pstl,
  libcxx,
  bintools-unwrapped,
  openmp,
  sycl,
  xpti,
  xptifw,
}:
wrapCCWith {
  inherit libcxx;

  bintools = wrapBintoolsWith {
    bintools = bintools-unwrapped;
  };
  cc = sycl;

  extraPackages = [
    compiler-rt
    pstl
    libcxx
    openmp
    xpti
    xptifw
  ];

  # TODO:     major = lib.versions.major release_version;
  extraBuildCommands = ''
    rsrc="$out/resource-root"
    mkdir "$rsrc"
    ln -s "${sycl}/lib/clang/19/include" "$rsrc"
    ln -s "${compiler-rt}/lib" "$rsrc/lib"
    ln -s "${compiler-rt}/share" "$rsrc/share"

    echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
  '';
}
