{
  description = "My system configuration";

  inputs = {
    templates.url = "github:MordragT/nix-templates";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nuenv = {
      # url = "github:DeterminateSystems/nuenv";
      url = "github:NotLebedev/nuenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    templates,
    nixpkgs,
    nur,
    chaotic,
    cosmic,
    disko,
    home-manager,
    classified,
    comoji,
    fenix,
    lanzaboote,
    nuenv,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        chaotic.overlays.default
        cosmic.overlays.default
        comoji.overlays.default
        fenix.overlays.default
        nur.overlay
        nuenv.overlays.default
        (import ./pkgs/overlay.nix)
      ];
    };
    lib = import ./lib.nix {
      inherit self nixpkgs home-manager templates;
    };
  in {
    nixosConfigurations = {
      tom-laptop = let
        stateVersion = "23.11";
      in
        lib.mkHost {
          inherit system stateVersion;

          imports = [
            ./modules
            ./hosts/laptop
            ./config/system
            ./config/services
            ./config/programs
            ./config/security.nix
            ./config/desktop-manager/gnome.nix
          ];

          modules = [
            classified.nixosModules.${system}.default
            chaotic.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
          ];

          specialArgs = {
            inherit pkgs;
          };

          homes = {
            "tom" = lib.mkHome {
              inherit stateVersion;
              username = "tom";
              imports = [./home];
            };

            "root" = lib.mkHome {
              inherit stateVersion;
              username = "root";
              imports = [
                ./home/programs/nushell.nix
              ];
            };
          };
        };

      tom-server = let
        stateVersion = "24.05";
      in
        lib.mkHost {
          inherit system stateVersion;

          imports = [
            ./modules
            ./hosts/server
            ./config/system
            ./config/security.nix
            ./config/services/openssh.nix
            ./config/services/samba.nix
            # ./config/services/maddy.nix
            # ./config/services/nextcloud.nix
            # ./config/services/gitea.nix
            # ./config/services/vaultwarden.nix
            ./config/programs/steam.nix
            ./config/desktop-manager/cosmic.nix
          ];

          modules = [
            classified.nixosModules.${system}.default
            chaotic.nixosModules.default
            cosmic.nixosModules.default
            disko.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
          ];

          specialArgs = {
            inherit pkgs;
          };

          homes = {
            "tom" = lib.mkHome {
              inherit stateVersion;
              username = "tom";
              imports = [
                ./home/programs/git.nix
                ./home/programs/nushell.nix
                ./home/programs/firefox.nix
                ./home/gaming.nix
                ./home/nix.nix
                ./home/gnome
              ];
            };

            "root" = lib.mkHome {
              inherit stateVersion;
              username = "root";
              imports = [
                ./home/programs/nushell.nix
              ];
            };
          };
        };

      tom-desktop = let
        stateVersion = "23.11";
      in
        lib.mkHost {
          inherit system stateVersion;

          imports = [
            ./modules
            ./hosts/desktop
            ./config/system
            ./config/services
            ./config/programs
            # no fractional scaling (https://github.com/YaLTeR/niri/issues/35)
            # ./config/programs/niri.nix
            # no security manager (wlroots issue https://gitlab.freedesktop.org/wlroots/wlroots/-/issues/3339)
            # ./config/programs/hyprland.nix
            ./config/security.nix
            ./config/virtualisation.nix
            # ./config/desktop-manager/gnome.nix
            ./config/desktop-manager/cosmic.nix
          ];

          modules = [
            classified.nixosModules.${system}.default
            chaotic.nixosModules.default
            cosmic.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
          ];

          specialArgs = {
            inherit pkgs;
          };

          homes = {
            "tom" = lib.mkHome {
              inherit stateVersion;
              username = "tom";
              imports = [
                ./home
                # ./home/window-manager/niri.nix
                ./home/window-manager/hyprland.nix
              ];
            };

            "root" = lib.mkHome {
              inherit stateVersion;
              username = "root";
              imports = [
                ./home/programs/git.nix
                ./home/programs/nushell.nix
              ];
            };
          };
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
            home.stateVersion = "23.11";
            programs.home-manager.enable = true;
            targets.genericLinux.enable = true;

            nix.package = pkgs.nixVersions.stable;
          })
          ./home
          chaotic.homeManagerModules.default
        ];
      };
    };

    nixosModules.default = import ./modules;
    packages."${system}" = import ./pkgs pkgs;
    overlays.default = import ./pkgs/overlay.nix;
    devShells."${system}".default = pkgs.mkShell {
      buildInputs = with pkgs; [
        disko.packages.${system}.default
        classified.defaultPackage.${system}
        unzip
        git
        nixos-generators
      ];
    };
  };
}
