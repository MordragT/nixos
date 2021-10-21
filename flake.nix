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
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.root = import ./home/root.nix {
              inherit inputs;      
            };
            home-manager.users.tom = import ./home/tom.nix {
              inherit inputs;    
            };
          }
          ./users/tom.nix
          ./users/root.nix
        ];   
        specialArgs = { inherit inputs; };
      };
    };
  };
}
