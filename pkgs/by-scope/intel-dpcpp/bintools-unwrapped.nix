{
  runCommand,
  llvm,
}:
runCommand "dpcpp-bintools-${llvm.version}" {preferLocalBuild = true;} ''
  mkdir -p $out/bin

  ln -s ${llvm}/bin/compiler/llvm-ar $out/bin/ar
  # ln -s ${llvm}/bin/compiler/llvm-as $out/bin/as
  # ln -s ${llvm}/bin/compiler/llvm-dwp $out/bin/dwp
  ln -s ${llvm}/bin/compiler/llvm-nm $out/bin/nm
  ln -s ${llvm}/bin/compiler/llvm-objcopy $out/bin/objcopy
  # ln -s ${llvm}/bin/compiler/llvm-objdump $out/bin/objdump
  ln -s ${llvm}/bin/compiler/llvm-ranlib $out/bin/ranlib
  # ln -s ${llvm}/bin/compiler/llvm-readelf $out/bin/readelf
  # ln -s ${llvm}/bin/compiler/llvm-size $out/bin/size
  # ln -s ${llvm}/bin/compiler/llvm-strip $out/bin/strip
  ln -s ${llvm}/bin/compiler/lld $out/bin/ld

  ln -s ${llvm}/bin/compiler/llvm-cov $out/bin/cov
  ln -s ${llvm}/bin/compiler/llvm-foreach $out/bin/foreach
  ln -s ${llvm}/bin/compiler/llvm-link $out/bin/link
  ln -s ${llvm}/bin/compiler/llvm-ml $out/bin/ml
  ln -s ${llvm}/bin/compiler/llvm-profgen $out/bin/profgen
  ln -s ${llvm}/bin/compiler/llvm-spirv $out/bin/spirv
  ln -s ${llvm}/bin/compiler/llvm-symbolizer $out/bin/symbolizer
''
