{
  runCommand,
  llvm,
}:
runCommand "dpcpp-bintools-${llvm.version}" {preferLocalBuild = true;} ''
  mkdir -p $out/bin

  ln -s ${llvm}/bin/compiler/llvm-ar $out/bin/ar
  ln -s ${llvm}/bin/compiler/llvm-nm $out/bin/nm
  ln -s ${llvm}/bin/compiler/llvm-objcopy $out/bin/objcopy
  ln -s ${llvm}/bin/compiler/llvm-ranlib $out/bin/ranlib
  ln -s ${llvm}/bin/compiler/lld $out/bin/ld
''
