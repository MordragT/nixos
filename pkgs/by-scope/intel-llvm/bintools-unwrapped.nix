{
  runCommand,
  llvm,
}:
runCommand "intel-llvm-bintools-${llvm.version}" {preferLocalBuild = true;} ''
  mkdir -p $out/bin

  ln -s ${llvm}/bin/llvm-ar $out/bin/ar
  ln -s ${llvm}/bin/llvm-as $out/bin/as
  ln -s ${llvm}/bin/llvm-dwp $out/bin/dwp
  ln -s ${llvm}/bin/llvm-nm $out/bin/nm
  ln -s ${llvm}/bin/llvm-objcopy $out/bin/objcopy
  ln -s ${llvm}/bin/llvm-objdump $out/bin/objdump
  ln -s ${llvm}/bin/llvm-ranlib $out/bin/ranlib
  ln -s ${llvm}/bin/llvm-readelf $out/bin/readelf
  ln -s ${llvm}/bin/llvm-size $out/bin/size
  ln -s ${llvm}/bin/llvm-strip $out/bin/strip
  ln -s ${llvm}/bin/lld $out/bin/ld
''
