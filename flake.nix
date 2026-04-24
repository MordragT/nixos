{
  description = "My system configuration";

  inputs = {
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

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "nixpkgs/nixos-unstable";

    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere";
      inputs = {
        disko.follows = "disko";
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    nu-env = {
      url = "github:MordragT/nu-env";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        git-hooks.follows = "git-hooks";
        flake-parts.follows = "flake-parts";
      };
    };

    qpad = {
      url = "github:MordragT/qpad";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    systems.url = "github:nix-systems/default";
    templates.url = "github:MordragT/nix-templates";

    valhali = {
      url = "github:MordragT/valhali";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vaultix = {
      url = "github:milieuim/vaultix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        inputs.git-hooks.flakeModule
        inputs.vaultix.flakeModules.default
        ./devshells
        ./home-modules
        ./hosts
        ./lib
        ./nixos-modules
        ./pkgs
      ];

      flake.vaultix = {
        # extraRecipients = [ ];                 # default, optional
        # cache = "./secrets/cache";             # default, optional
        # defaultSecretDirectory = "./secrets";  # default, optional
        # nodes = self.nixosConfigurations;      # default, optional
        # extraPackages = [ ];                   # default, optional
        # pinentryPackage = null;                # default, optional
        nodes = {
          inherit (inputs.self.nixosConfigurations) tom-desktop;
        };
        identity = "~/.config/age/keys.txt";
      };

      perSystem =
        { pkgs, ... }:
        {
          pre-commit = {
            settings = {
              package = pkgs.prek;
              hooks = {
                nixfmt = {
                  enable = true;
                  id = "nixfmt";
                  after = [ "statix" ];
                };
                statix = {
                  enable = true;
                  id = "statix";
                };
                yamllint = {
                  enable = true;
                  settings.configuration = ''
                    rules:
                      truthy:
                        check-keys: false
                  '';
                };
              };
            };
          };
        };
    };

}
