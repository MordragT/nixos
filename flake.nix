{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur-community.url = "github:nix-community/NUR";
    gitmoji.url = "github:MordragT/gitmoji-cli";
  };

  outputs = { self, nixpkgs, home-manager, nur-community, gitmoji, ... }@inputs: 
  let
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        nur-community.overlay    
      ];
      packageOverrides = pkgs: {
        gitmoji = import gitmoji {};
      };
    };
      
    system = "x86_64-linux";
    # nur = import nur-community {
    #   inherit pkgs;
    # };
  in {         
    nixosConfigurations = {
      "tom-laptop" = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/laptop.nix
          ./system/default.nix
          ./features/self-hosting.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.root = import ./home/root.nix {
              inherit system pkgs;      
            };
            home-manager.users.tom = import ./home/tom.nix {
              inherit system pkgs;    
            };
          }
        ];   
        specialArgs = { inherit system inputs; };
      };
    };
  };
}
