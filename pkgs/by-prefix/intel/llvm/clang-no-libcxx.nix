{
  wrapCCWith,
  wrapBintoolsWith,
  glibc,
  compiler-rt,
  llvm,
  bintools-unwrapped,
}:
wrapCCWith {
  bintools = wrapBintoolsWith {
    bintools = bintools-unwrapped;
    libc = glibc;
  };
  cc = llvm;
  libc = glibc;

  extraPackages = [
    compiler-rt
  ];

  # TODO:     major = lib.versions.major release_version;
  extraBuildCommands = ''
    rsrc="$out/resource-root"
    mkdir "$rsrc"
    ln -s "${llvm}/lib/clang/19/include" "$rsrc"
    ln -s "${compiler-rt}/lib" "$rsrc/lib"
    ln -s "${compiler-rt}/share" "$rsrc/share"

    echo "-resource-dir=$rsrc" >> $out/nix-support/cc-cflags
  '';

  nixSupport.cc-cflags = [
    "-nostdlib++"
  ];
}
