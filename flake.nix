{
  description = "My system configuration";

  inputs = {
    templates.url = "github:MordragT/nix-templates";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
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
    fenix = {
      url = "github:nix-community/fenix/monthly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    templates,
    nixpkgs,
    nur,
    chaotic,
    home-manager,
    classified,
    comoji,
    fenix,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        chaotic.overlays.default
        comoji.overlays.default
        fenix.overlays.default
        nur.overlay
        (import ./overlay.nix)
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
          classified.nixosModules.${system}.default
          chaotic.nixosModules.default
        ];

        specialArgs = {
          inherit pkgs;
        };

        specialHomeArgs = {
          inherit templates;
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
          classified.nixosModules.${system}.default
          chaotic.nixosModules.default
        ];

        specialArgs = {
          inherit pkgs;
        };

        specialHomeArgs = {
          inherit templates;
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
              ./config/impermanence.nix
              ./config/security.nix
              ./config/virtualisation.nix
              ./config/desktop-manager/gnome.nix
              ./config/desktop-manager/cosmic.nix
            ];
          }
          classified.nixosModules.${system}.default
          chaotic.nixosModules.default
        ];

        specialArgs = {
          inherit pkgs;
        };

        specialHomeArgs = {
          inherit templates;
        };

        homes =
          (lib.mkHome {
            inherit stateVersion;
            username = "tom";
            imports = [
              ./home
            ];
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
