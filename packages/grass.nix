{ system
, lib
, pkgs
}:
(pkgs.makeRustPlatform {
  inherit (pkgs.fenix.minimal) cargo rustc;
}).buildRustPackage {
  pname = "grass";
  version = "0.11.0";
  src =
    let
      source = pkgs.fetchFromGitHub {
        owner = "connorskees";
        repo = "grass";
        rev = "fa5789aa977e096d3283c0c2b0b058f895913717";
        sha256 = "DmuiBJf5W2H+dlAOVEZ5GtqkHMBJ4xXnho1GCKGKUOM=";
      };
    in
    pkgs.runCommand "source" { } ''
      cp -R ${source} $out
      chmod +w $out
      cp ${./grass.lock} $out/Cargo.lock
    '';

  cargoSha256 = "f9y2YGIqWQz4BeS7bRRSFNf8/FaYWSaWHOhxbWsmV5M=";

  nativeBuildInputs = with pkgs; [ clang ];
}
