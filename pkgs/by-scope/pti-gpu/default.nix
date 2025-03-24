self: pkgs: let
  version = "0.10.1";
  src = pkgs.fetchFromGitHub {
    owner = "intel";
    repo = "pti-gpu";
    rev = "pti-${version}";
    hash = "sha256-fJkLEaUvhWw2vyQvO0bTHBnH/g//gbVCLmJfRumM598=";
  };
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
in {
  onetrace = callPackage ./onetrace.nix {
    inherit src version;
  };

  sysmon = callPackage ./sysmon.nix {
    inherit src version;
  };

  sdk = callPackage ./sdk.nix {
    inherit src version;
  };
}
