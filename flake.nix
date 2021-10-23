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
    mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
  };

  outputs = {
    self
    , nixpkgs
    , home-manager
    , naersk
    , fenix
    , agenix
    , nur-community
    , gitmoji
    , mailserver
    , ... 
  }@inputs: 
  let
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        nur-community.overlay    
        agenix.overlay
        (final: prev: { local.gitmoji = prev.callPackage gitmoji {
          inherit naersk fenix;    
        }; })
      ];
    };      
    system = "x86_64-linux";
  in {         
    nixosConfigurations = {
      "tom-laptop" = nixpkgs.lib.nixosSystem {
        inherit system;
            
        modules = [
          mailserver.nixosModules.mailserver
          agenix.nixosModules.age
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
          ./hosts/laptop.nix
          ./system/default.nix
          ./services/vaultwarden.nix
          ./services/gitea.nix
          ./services/caddy.nix
          ./services/nextcloud.nix
          ./services/step-ca.nix
          ./services/mailserver.nix
          ./services/default.nix
          # ./services/roundcube.nix
        ];   
            
        specialArgs = {
          inherit system pkgs inputs;
        };
      };
    };
  };
}
