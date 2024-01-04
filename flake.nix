{
  description = "My system configuration";

  inputs = {
    nixpkgs-master.url = "nixpkgs/staging-next";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-matlab = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "gitlab:doronbehar/nix-matlab";
    };
    fenix = {
      url = "github:nix-community/fenix/monthly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    js-bp = {
      url = "github:serokell/nix-npm-buildpackage";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gomod2nix = {
      url = "github:tweag/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    classified = {
      url = "github:GoldsteinE/classified";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    comoji = {
      url = "github:MordragT/comoji";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    templates.url = "github:MordragT/nix-templates";
  };

  outputs = {
    self,
    nixpkgs-master,
    nixpkgs,
    chaotic,
    nur,
    home-manager,
    nix-alien,
    nix-index-database,
    nix-matlab,
    fenix,
    js-bp,
    gomod2nix,
    classified,
    comoji,
    templates,
  }: let
    system = "x86_64-linux";
    master = import nixpkgs-master {
      inherit system;
    };
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        nix-alien.overlays.default
        nix-matlab.overlay
        chaotic.overlays.default
        nur.overlay
        comoji.overlays.default
        fenix.overlays.default
        js-bp.overlays.default
        gomod2nix.overlays.default
        (import ./overlay.nix)
        # (self: pkgs: {mesa = master.mesa;})
      ];
    };
    lib = import ./lib {inherit nixpkgs pkgs home-manager;};
  in {
    nixosConfigurations = {
      tom-laptop = lib.mkHost rec {
        inherit system;
        stateVersion = "23.11";
        modules = [
          {
            imports = [
              ./modules
              ./hosts/laptop
              ./config/system
              ./config/services
              ./config/programs
              ./config/security.nix
              ./config/desktop-manager/gnome.nix
            ];
          }
          nix-index-database.nixosModules.nix-index
          classified.nixosModules.${system}.default
          chaotic.nixosModules.default
        ];

        specialArgs = {
          inherit pkgs master;
        };

        specialHomeArgs = {
          inherit templates master;
        };

        homes =
          (lib.mkHome {
            inherit stateVersion;
            username = "tom";
            imports = [./home];
          })
          // (lib.mkHome {
            inherit stateVersion;
            username = "root";
            homeDirectory = "/root";
            imports = [
              ./home/programs/nushell.nix
            ];
          });
      };

      tom-server = lib.mkHost rec {
        inherit system;
        stateVersion = "23.05";
        modules = [
          {
            imports = [
              ./modules
              ./hosts/server
              ./config/system
              ./config/services/openssh.nix
              ./config/services/samba.nix
              # ./config/services/maddy.nix
              # ./config/services/nextcloud.nix
              # ./config/services/gitea.nix
              # ./config/services/vaultwarden.nix
              ./config/programs/steam.nix
              ./config/programs/comma.nix
              ./config/security.nix
              ./config/desktop-manager/plasma-bigscreen.nix
            ];
          }
          nix-index-database.nixosModules.nix-index
          classified.nixosModules.${system}.default
          chaotic.nixosModules.default
        ];

        specialArgs = {
          inherit pkgs master;
        };

        specialHomeArgs = {
          inherit templates master;
        };

        homes =
          (lib.mkHome {
            inherit stateVersion;
            username = "tom";
            imports = [
              ./home/programs/git.nix
              ./home/programs/nushell.nix
              ./home/programs/firefox.nix
              ./home/gaming.nix
              ./home/plasma.nix
            ];
          })
          // (lib.mkHome {
            inherit stateVersion;
            username = "root";
            homeDirectory = "/root";
            imports = [
              ./home/programs/nushell.nix
            ];
          });
      };

      tom-desktop = lib.mkHost rec {
        inherit system;
        stateVersion = "23.11";
        modules = [
          {
            imports = [
              ./modules
              ./hosts/desktop
              ./config/system
              ./config/services
              ./config/services/pia-wg.nix
              ./config/programs
              ./config/security.nix
              ./config/virtualisation.nix
              ./config/desktop-manager/gnome.nix
              ./config/desktop-manager/cosmic.nix
            ];
          }
          nix-index-database.nixosModules.nix-index
          classified.nixosModules.${system}.default
          chaotic.nixosModules.default
        ];

        specialArgs = {
          inherit pkgs master;
        };

        specialHomeArgs = {
          inherit templates master;
        };

        homes =
          (lib.mkHome {
            inherit stateVersion;
            username = "tom";
            imports = [./home];
          })
          // (lib.mkHome {
            inherit stateVersion;
            username = "root";
            homeDirectory = "/root";
            imports = [
              ./home/programs/git.nix
              ./home/programs/nushell.nix
            ];
          });
      };
    };

    homeConfigurations = {
      tom = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        extraSpecialArgs = {
          inherit templates;
        };

        modules = [
          ({pkgs, ...}: {
            home.username = "tom";
            home.homeDirectory = "/home/tom";
            home.stateVersion = "22.11";
            programs.home-manager.enable = true;
            targets.genericLinux.enable = true;

            nix.package = pkgs.nixVersions.stable;
          })
          ./home
          chaotic.homeManagerModules.default
        ];
      };
    };

    overlays.default = import ./overlay.nix;
    devShells."${system}" = import ./shells {inherit pkgs;};
  };
}
