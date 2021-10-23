{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    naersk.url = "github:nmattia/naersk";
    fenix.url = "github:nix-community/fenix";
    agenix.url = "github:ryantm/agenix";
    nur-community.url = "github:nix-community/NUR";
    gitmoji.url = "github:MordragT/gitmoji-cli";
  };

  outputs = { self, nixpkgs, home-manager, naersk, fenix, agenix, nur-community, gitmoji, ... }@inputs: 
  let
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        nur-community.overlay    
        (final: prev: { local.gitmoji = prev.callPackage gitmoji {
          inherit naersk fenix;    
        }; })
      ];
      # packageOverrides = pkgs: {
      #   gitmoji = gitmoji.packages.gitmoji;
      # };
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
          # agenix.nixosModules.age
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.root = import ./home/root.nix {
              inherit system pkgs;      
            };
            home-manager.users.tom = import ./home/tom.nix {
              inherit system pkgs;    
              # gitmoji = gitmoji.packages.gitmoji;
            };
          }
        ];   
        specialArgs = { inherit system inputs; };
      };
    };
  };
}
