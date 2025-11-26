{
  runCommand,
  llvm,
  lld,
}:
runCommand "intel-sycl-bintools-${llvm.version}" {preferLocalBuild = true;} ''
  mkdir -p $out/bin

  ln -s ${llvm}/bin/llvm-ar $out/bin/ar
  ln -s ${llvm}/bin/llvm-objcopy $out/bin/objcopy
  ln -s ${llvm}/bin/llvm-size $out/bin/size
  ln -s ${lld}/bin/lld $out/bin/ld

  ln -s ${llvm}/bin/llvm-cov $out/bin/cov
  ln -s ${llvm}/bin/llvm-foreach $out/bin/foreach
  ln -s ${llvm}/bin/llvm-link $out/bin/link
  ln -s ${llvm}/bin/llvm-profdata $out/bin/profdata
  ln -s ${llvm}/bin/llvm-spirv $out/bin/spirv
''
