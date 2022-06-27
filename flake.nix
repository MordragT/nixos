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
    js-bp = {
      url = "github:serokell/nix-npm-buildpackage";
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
    comoji = {
      url = "github:MordragT/comoji";
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
    , js-bp
    , agenix
    , nur-community
    , comoji
    , mailserver
    , hua
    , ... 
  }@inputs: 
  let
    overlay = (name: path: final: prev: {
      "${name}" = prev.callPackage (import path) {};
    });
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (overlay "webex" ./packages/webex.nix)
        (overlay "spflashtool" ./packages/spflashtool.nix)
        (overlay "astrofox" ./packages/astrofox.nix)
        # (custom-overlay "webdesigner" ./packages/webdesigner.nix)
        nur-community.overlay    
        agenix.overlay
        comoji.overlay
        hua.overlay
        fenix.overlay
        naersk.overlay
        js-bp.overlays.default
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
              home-manager.users.root = import ./users/root.nix {
                  inherit system pkgs;      
              };
              home-manager.users.tom = import ./users/tom.nix {
                  inherit system pkgs;    
              };
          }
          ./system/laptop
          ./system
          ./services
          ./virtualization
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
              home-manager.users.root = import ./users/root.nix {
                  inherit system pkgs;      
              };
              home-manager.users.tom = import ./users/tom.nix {
                  inherit system pkgs;    
              };
          }
          ./system/desktop
          ./system
          ./services
          ./virtualization
        ];   
            
        specialArgs = {
          inherit system pkgs inputs;
        };
      };
    };
  };
}
