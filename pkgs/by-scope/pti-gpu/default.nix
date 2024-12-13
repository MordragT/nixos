self: pkgs: let
  version = "0.10.0";
  src = pkgs.fetchFromGitHub {
    owner = "intel";
    repo = "pti-gpu";
    rev = "pti-${version}";
    hash = "sha256-CymStJNvGPIkvG0YTig5Ugv4tAyyVN4Oq7Dq6JUHyAE=";
  };
  callPackage = pkgs.lib.callPackageWith (pkgs // self);
in {
  sysmon = callPackage ./sysmon.nix {
    inherit src version;
  };

  sdk = callPackage ./sdk.nix {
    inherit src version;
  };
}
