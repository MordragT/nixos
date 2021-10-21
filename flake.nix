{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur-community.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, nur-community, ... }@inputs: 
  let
    pkgs = import nixpkgs {
      # inherit system;
      config.allowUnfree = true;
      overlays = [];
    };
  in {         
    nixosConfigurations = {
      "tom-laptop" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/laptop.nix
          ./system/default.nix
          ./features/self-hosting.nix
          ./users/tom.nix
          ./users/root.nix
        ];   
        specialArgs = { inherit inputs; };
      };
    };
  };
}
