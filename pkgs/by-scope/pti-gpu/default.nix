self: pkgs: let
  version = "unstable-2024-06-20";
  src = pkgs.fetchFromGitHub {
    owner = "intel";
    repo = "pti-gpu";
    rev = "1b7929b8139b09b03127c92211a9be2be9fb900e";
    hash = "sha256-K5+OofZ3BrufEoKibzBSegdzzBS7La7e5BRv8tMYV2s=";
  };
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
in {
  sysmon = callPackage ./sysmon.nix {
    inherit src version;
  };
}
