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
    valhali = {
      url = "github:MordragT/valhali";
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
    valhali,
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
      installer = let
        stateVersion = "24.05";
      in
        lib.mkHost {
          inherit system stateVersion;

          imports = [
            ./config/nix.nix
            ./hosts/installer.nix
          ];

          specialArgs = {
            inherit pkgs;
          };

          homes = {
            "nixos" = lib.mkHome {
              inherit stateVersion;
              username = "nixos";
              imports = [
                ./home/installer.nix
              ];
            };
          };
        };

      tom-laptop = let
        stateVersion = "23.11";
      in
        lib.mkHost {
          inherit system stateVersion;

          imports = [
            ./config
            ./hosts/laptop
            ./modules
          ];

          modules = [
            classified.nixosModules.${system}.default
            chaotic.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
            valhali.nixosModules.default
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
          };
        };

      tom-server = let
        stateVersion = "24.05";
      in
        lib.mkHost {
          inherit system stateVersion;

          imports = [
            ./config
            ./hosts/server
            ./modules
          ];

          modules = [
            classified.nixosModules.${system}.default
            chaotic.nixosModules.default
            cosmic.nixosModules.default
            disko.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
            valhali.nixosModules.default
          ];

          specialArgs = {
            inherit pkgs;
          };

          homes = {
            "tom" = lib.mkHome {
              inherit stateVersion;
              username = "tom";
              imports = [
                ./home/server.nix
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
            ./config
            ./hosts/desktop
            ./modules
          ];

          modules = [
            classified.nixosModules.${system}.default
            chaotic.nixosModules.default
            cosmic.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
            valhali.nixosModules.default
          ];

          specialArgs = {
            inherit pkgs;
          };

          homes = {
            "tom" = lib.mkHome {
              inherit stateVersion;
              username = "tom";
              imports = [
                ./home/desktop.nix
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
          ./home/laptop.nix
          chaotic.homeManagerModules.default
        ];
      };
    };

    homeManagerModules.default = import ./home/modules;
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
