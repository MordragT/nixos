{
  description = "Secrets devshell";

  inputs.classified.url = "github:GoldsteinE/classified";
  inputs.utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    classified,
    utils,
  }:
    utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            classified.defaultPackage.${system}
          ];
        };
      }
    );
}
