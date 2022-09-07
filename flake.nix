{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
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
    gomod2nix = {
      url = "github:tweag/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur-community = {
      url = "github:nix-community/NUR";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    comoji = {
      url = "github:MordragT/comoji";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hua = {
      url = "github:MordragT/hua";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # notes.url = "github:MordragT/notes";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , fenix
    , js-bp
    , gomod2nix
    , agenix
    , nur-community
    , comoji
    , mailserver
    , microvm
    , hua
      # , notes
    }@inputs:
    let
      overlay = (name: path: final: prev: {
        "${name}" = prev.callPackage (import path) { };
      });
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (overlay "grass" ./packages/grass.nix)
          (overlay "lottieconv" ./packages/lottieconv.nix)
          (overlay "webex" ./packages/webex.nix)
          (overlay "spflashtool" ./packages/spflashtool.nix)
          (overlay "astrofox" ./packages/astrofox.nix)
          #(overlay "superview" ./packages/superview.nix)
          #(overlay "dandere2x" ./packages/dandere2x.nix)
          # (custom-overlay "webdesigner" ./packages/webdesigner.nix)
          nur-community.overlay
          agenix.overlay
          comoji.overlay
          hua.overlay
          # notes.overlay
          fenix.overlay
          js-bp.overlays.default
          gomod2nix.overlays.default
        ];
      };
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        "tom-laptop" = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            mailserver.nixosModules.mailserver
            agenix.nixosModules.age
            home-manager.nixosModules.home-manager
            {
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
            home-manager.nixosModules.home-manager
            {
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

            ({ ... }: {
              nix.registry = {
                nixpkgs.flake = nixpkgs;
                microvm.flake = self;
              };
            })

            microvm.nixosModules.host
            {
              microvm.vms.vm =
                {
                  flake = self;
                  updateFlake = "microvm";
                };
              # microvm.autostart = [ "vm" ];
            }
          ];

          specialArgs = {
            inherit system pkgs inputs;
          };
        };

        # vm must use dhcp otherwise not working
        # probably due to misconfiguration
        vm = nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            microvm.nixosModules.microvm
            {
              system.stateVersion =
                "22.11";

              services.sshd.enable = true;
              environment.systemPackages = with pkgs; [

              ];

              networking = {
                hostName = "vm";
                #useDHCP = false;
                firewall = {
                  enable = true;
                  allowedTCPPorts = [ 22 ];
                };
                # useNetworkd = true;

                interfaces.eth0 = {
                  ipv4 = {
                    addresses = [
                      { address = "192.168.1.80"; prefixLength = 32; }
                    ];
                    # routes = [
                    #   {
                    #     address = "192.168.1.0";
                    #     prefixLength = 24;
                    #     via = "192.168.240.0";
                    #   }
                    # ];
                  };
                };
              };

              # systemd.network = {
              #   enable = true;
              #   networks.uplink = {
              #     matchConfig = { Name = "eth0"; };
              #     address = [ "192.168.240.80/24" ];
              #     dns = [ "1.1.1.1" "8.8.8.8" "4.4.4.4" ];
              #     gateway = [ "192.168.240.0" ];
              #   };
              # };

              users.users = {
                root.password = "";
                netzag = {
                  isNormalUser = true;
                  extraGroups = [ "wheel" "docker" ];
                  password = "test";
                };
              };

              microvm = {
                interfaces = [{
                  type = "tap";
                  id = "vm-a1";
                  mac = "02:00:00:00:00:01";
                }];

                volumes = [{
                  mountPoint = "/var";
                  image = "var.img";
                  size = 256;
                }];

                shares = [{
                  # use "virtiofs" for MicroVMs that are started by systemd
                  proto = "virtiofs";
                  tag = "ro-store";
                  socket = "ro-store.socket";
                  # a host's /nix/store will be picked up so that the
                  # size of the /dev/vda can be reduced.
                  source = "/nix/store";
                  mountPoint = "/nix/.ro-store";
                }];

                socket = "control.socket";
                # relevant for delarative MicroVM management
                hypervisor = "cloud-hypervisor";
              };
            }
          ];
        };
      };
    };
}
