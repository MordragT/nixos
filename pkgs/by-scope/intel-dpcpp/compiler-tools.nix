{
  runCommand,
  llvm,
}:
runCommand "dpcpp-compiler-tools-${llvm.version}" {preferLocalBuild = true;} ''
  mkdir -p "$out/bin"

  for f in ${llvm}/bin/compiler/*; do
    name="$(basename "$f")"
    ln -s "$f" "$out/bin/$name"
  done
''
