{
  description = "My system configuration";

  inputs = {
    templates.url = "github:MordragT/nix-templates";
    # nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs.follows = "cosmic/nixpkgs";
    nur.url = "github:nix-community/NUR";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      # inputs.nixpkgs.follows = "nixpkgs";
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
    nu-env = {
      url = "github:MordragT/nu-env";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    private = {
      url = "git+ssh://git@github.com/MordragT/nix-private";
      # url = "github:MordragT/nix-private";
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
    nu-env,
    private,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        chaotic.overlays.default
        cosmic.overlays.default
        comoji.overlays.default
        fenix.overlays.default
        nur.overlays.default
        nu-env.overlays.default
        private.overlays.default
        (import ./pkgs/overlay.nix)
      ];
      config.allowUnfree = true;
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
          inherit system stateVersion pkgs;

          imports = [
            ./system/modules
            ./system/config/installer
          ];

          homes = {
            "nixos" = lib.mkHome {
              inherit stateVersion;
              username = "nixos";
              imports = [
                ./home/modules
                ./home/config/installer
              ];
            };
          };
        };

      tom-laptop = let
        stateVersion = "23.11";
      in
        lib.mkHost {
          inherit system stateVersion pkgs;

          imports = [
            ./system/modules
            ./system/config/laptop
          ];

          modules = [
            classified.nixosModules.${system}.default
            chaotic.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
            valhali.nixosModules.default
          ];

          homes = {
            "tom" = lib.mkHome {
              inherit stateVersion;
              username = "tom";
              imports = [
                ./home/modules
                ./home/config/laptop
              ];
            };
          };
        };

      tom-server = let
        stateVersion = "24.05";
      in
        lib.mkHost {
          inherit system stateVersion pkgs;

          imports = [
            ./system/modules
            ./system/config/server
          ];

          modules = [
            classified.nixosModules.${system}.default
            chaotic.nixosModules.default
            cosmic.nixosModules.default
            disko.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
            valhali.nixosModules.default
          ];

          homes = {
            "tom" = lib.mkHome {
              inherit stateVersion;
              username = "tom";
              imports = [
                ./home/modules
                ./home/config/server
              ];
            };
          };
        };

      tom-desktop = let
        stateVersion = "23.11";
      in
        lib.mkHost {
          inherit system stateVersion pkgs;

          imports = [
            ./system/modules
            ./system/config/desktop
          ];

          modules = [
            classified.nixosModules.${system}.default
            chaotic.nixosModules.default
            cosmic.nixosModules.default
            lanzaboote.nixosModules.lanzaboote
            valhali.nixosModules.default
          ];

          homes = {
            "tom" = lib.mkHome {
              inherit stateVersion;
              username = "tom";
              imports = [
                ./home/modules
                ./home/config/desktop
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
          ./home/modules
          ./home/config/laptop
          chaotic.homeManagerModules.default
          ({pkgs, ...}: {
            home.username = "tom";
            home.homeDirectory = "/home/tom";
            home.stateVersion = "23.11";
            programs.home-manager.enable = true;
            targets.genericLinux.enable = true;

            nix.package = pkgs.nixVersions.stable;
          })
        ];
      };
    };

    homeManagerModules.default = import ./home/modules;
    nixosModules.default = import ./system/modules;
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
