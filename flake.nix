{
  description = "My system configuration";

  inputs = {
    # chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    classified = {
      url = "github:GoldsteinE/classified";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    comoji = {
      url = "github:MordragT/comoji";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cosmic-unstable.url = "github:ninelore/nixpkgs-cosmic-unstable";

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

    # private = {
    #   url = "git+ssh://git@github.com/MordragT/nix-private";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    templates.url = "github:MordragT/nix-templates";

    valhali = {
      url = "github:MordragT/valhali";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    # chaotic,
    classified,
    comoji,
    cosmic-unstable,
    disko,
    fenix,
    home-manager,
    lanzaboote,
    nixpkgs,
    nu-env,
    nur,
    # private,
    templates,
    valhali,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        # chaotic.overlays.default
        comoji.overlays.default
        # cosmic-unstable.overlays.default
        fenix.overlays.default
        nu-env.overlays.default
        nur.overlays.default
        # private.overlays.default
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
            # chaotic.nixosModules.default
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
            # chaotic.nixosModules.default
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
            # chaotic.nixosModules.default
            classified.nixosModules.${system}.default
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
          # chaotic.homeManagerModules.default
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

    packages."${system}" =
      (import ./pkgs pkgs)
      // {
        # tom-desktop-vm = nixos-generators.nixosGenerate {
        #   inherit system;
        #   format = "vm";
        #   modules = [];
        # };

        # tom-server-vm = nixos-generators.nixosGenerate {
        #   inherit system;
        #   format = "vm";
        #   modules = [];
        # };

        # tom-laptop-vm = nixos-generators.nixosGenerate {
        #   inherit system;
        #   format = "vm";
        #   modules = [];
        # };

        tom-desktop-vm = self.nixosConfigurations.tom-desktop.config.system.build.vm;
        tom-laptop-vm = self.nixosConfigurations.tom-laptop.config.system.build.vm;
        tom-server-vm = self.nixosConfigurations.tom-server.config.system.build.vm;
      };
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
