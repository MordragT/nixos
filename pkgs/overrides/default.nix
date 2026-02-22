final: prev:
let
  inherit (prev) callPackage;
  pins = import ./pins.nix { inherit (prev.stdenv.hostPlatform) system; };
in
{
  invokeai = with final.intel-python.pkgs; toPythonApplication invokeai;
  marker-pdf = with final.intel-python.pkgs; toPythonApplication marker-pdf;
  steamtinkerlaunch = callPackage ./steamtinkerlaunch { };
  # stirling-pdf = pins.stirling-pdf.stirling-pdf;
}
