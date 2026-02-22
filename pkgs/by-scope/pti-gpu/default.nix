global: self:
let
  inherit (global) callPackage;
  version = "0.15.0";
  src = global.fetchFromGitHub {
    owner = "intel";
    repo = "pti-gpu";
    rev = "pti-${version}";
    hash = "sha256-wBVSsCWh7oB7Hpthn4adQsHRJ98XnYCJWP0qrynrTAQ=";
  };
in
{
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
