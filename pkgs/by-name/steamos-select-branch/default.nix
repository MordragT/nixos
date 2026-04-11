{ writeShellScriptBin }:
writeShellScriptBin "steamos-select-branch" ''
  case "$1" in
    "-c")
      # Current Branch
      echo "main"
      ;;
    "-l")
      # List Branches
      echo "main"
      ;;
    *)
      # Switch Branch
      ;;
  esac
''
