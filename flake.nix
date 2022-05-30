{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    naersk = {
      url = "github:nmattia/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur-community = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gitmoji = {
      url = "github:MordragT/gitmoji-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hua = {
      url = "github:MordragT/hua";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    , hua
    , ... 
  }@inputs: 
  let
    rust-overlay = (name: path: final: prev: {
        "${name}" = prev.callPackage (import path) {
          inherit naersk fenix;
        };  
    });
    custom-overlay = (name: path: final: prev: {
      "${name}" = prev.callPackage (import path) {};
    });
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (rust-overlay "findex" ./packages/findex.nix)
        (custom-overlay "webex" ./packages/webex.nix)
        (custom-overlay "spflashtool" ./packages/spflashtool.nix)
        # (custom-overlay "webdesigner" ./packages/webdesigner.nix)
        nur-community.overlay    
        agenix.overlay
        gitmoji.overlay
        hua.overlay
        fenix.overlay
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
          ./hosts/laptop
          ./system/default.nix
          ./services/vaultwarden.nix
          ./services/gitea.nix
          ./services/caddy.nix
          ./services/nextcloud.nix
          ./services/step-ca.nix
          ./services/mailserver.nix
          ./services/default.nix
          ./services/pia.nix
          # ./services/roundcube.nix
        ];   
            
        specialArgs = {
          inherit system pkgs inputs;
        };
      };
            
      "tom-pc" = nixpkgs.lib.nixosSystem {
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
          ./hosts/desktop
          ./system/default.nix
          ./services/vaultwarden.nix
          ./services/gitea.nix
          ./services/caddy.nix
          ./services/nextcloud.nix
          ./services/step-ca.nix
          ./services/mailserver.nix
          ./services/default.nix
          ./services/pia.nix
          # ./services/roundcube.nix
        ];   
            
        specialArgs = {
          inherit system pkgs inputs;
        };
      };
    };
  };
}
