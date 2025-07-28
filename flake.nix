{
  description = "My system configuration";

  inputs = {
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    classified = {
      url = "github:GoldsteinE/classified";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    comoji = {
      url = "github:MordragT/comoji";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fenix = {
      url = "github:nix-community/fenix/monthly";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jovian = {
      url = "github:Jovian-Experiments/Jovian-Nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "nixpkgs/nixos-unstable";

    nu-env = {
      url = "github:MordragT/nu-env";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    private = {
      url = "git+ssh://git@github.com/MordragT/nix-private";
      # url = "github:MordragT/nix-private";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    templates.url = "github:MordragT/nix-templates";

    valhali = {
      url = "github:MordragT/valhali";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    chaotic,
    classified,
    comoji,
    disko,
    fenix,
    home-manager,
    jovian,
    lanzaboote,
    nixpkgs,
    nu-env,
    nur,
    private,
    templates,
    valhali,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        chaotic.overlays.default
        comoji.overlays.default
        fenix.overlays.default
        jovian.overlays.default
        nu-env.overlays.default
        nur.overlays.default
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
        stateVersion = "25.11";
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
            chaotic.nixosModules.default
            classified.nixosModules.${system}.default
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
            chaotic.nixosModules.default
            classified.nixosModules.${system}.default
            disko.nixosModules.default
            jovian.nixosModules.default
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
            chaotic.nixosModules.default
            classified.nixosModules.${system}.default
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
            home.stateVersion = "25.11";
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
