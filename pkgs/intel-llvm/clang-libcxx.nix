{
  wrapCCWith,
  wrapBintoolsWith,
  compiler-rt,
  libcxx,
  llvm,
  bintools-unwrapped,
}:
wrapCCWith {
  inherit libcxx;

  bintools = wrapBintoolsWith {
    bintools = bintools-unwrapped;
  };
  cc = llvm;

  extraPackages = [
    compiler-rt
    libcxx
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
}
