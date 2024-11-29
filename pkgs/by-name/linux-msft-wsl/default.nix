{
  fetchFromGitHub,
  buildLinux,
  ...
} @ args:
buildLinux (
  args
  // rec {
    version = "6.6.36.6";
    modDirVersion = version;

    src = fetchFromGitHub {
      owner = "microsoft";
      repo = "WSL2-Linux-Kernel";
      rev = "e458890574d4b6d635880180ef9e5d2b621ff577";
      hash = "";
    };

    kernelPatches = [];
    extraConfig = builtins.readFile "$src/arch/x86/configs/config-wsl";

    extraMeta.branch = "6.6";
  }
  // (args.argsOverride or {})
)
