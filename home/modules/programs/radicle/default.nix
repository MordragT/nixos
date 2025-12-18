{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.mordrag.programs.radicle;

  radicleHome = config.home.homeDirectory + "/.radicle";
in {
  options.mordrag.programs.radicle = {
    enable = lib.mkEnableOption "Radicle";
  };

  config = lib.mkIf cfg.enable {
    programs.radicle = {
      enable = true;

      settings = {
        cli.hints = true;

        node = {
          alias = "mordrag";
          seedingPolicy.default = "block";
        };

        preferredSeeds = [
          "z6MkrLMMsiPWUcNPHcRajuMi9mDfYckSoJyPwwnknocNYPm7@iris.radicle.xyz:8776"
          "z6Mkmqogy2qEM2ummccUthFEaaHvyYmYBYh3dbe9W4ebScxo@rosa.radicle.xyz:8776"
        ];

        publicExplorer = "https://app.radicle.xyz/nodes/$host/$rid$path";

        web = {
          avatarUrl = "https://mordrag.de/img/mordrag.webp";
          # bannerUrl = "";
          description = "Truly local first radicle code forge";

          pinned.repositories = [
            "rad:z3gqcJUoA1n9HaHKufZs5FCSGazv5"
          ];
        };
      };
    };

    home.packages = with pkgs; [
      radicle-desktop
    ];

    services.radicle.node = {
      enable = true;
    };

    systemd.user.services."radicle-httpd" = {
      Unit = {
        Description = "Radicle HTTP gateway (user)";
        Documentation = ["man:radicle-httpd(1)"];
        After = ["radicle-node.service"];
        Requires = ["radicle-node.service"];
      };
      Service = lib.mkMerge [
        {
          Slice = "session.slice";
          ExecStart = lib.escapeShellArgs [
            (lib.getExe' pkgs.radicle-httpd "radicle-httpd")
            "--listen=127.0.0.1:8080"
          ];
          Environment = [
            "RAD_HOME=${radicleHome}"
          ];
          KillMode = "process";
          Restart = "on-failure";
          RestartSec = "5";
        }
        {
          # lightweight hardening similar to node service
          BindPaths = [
            "${radicleHome}/storage"
            "${radicleHome}/node"
            "${radicleHome}/cobs"
          ];
          BindReadOnlyPaths = [
            "${radicleHome}/config.json"
            "${radicleHome}/keys"
            "-/etc/resolv.conf"
            "/run/systemd"
          ];
          RestrictAddressFamilies = ["AF_UNIX" "AF_INET" "AF_INET6"];
          AmbientCapabilities = "";
          CapabilityBoundingSet = "";
          NoNewPrivileges = true;
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateUsers = "self";
          ProtectSystem = "strict";
          ProtectHome = "tmpfs";
          ProtectKernelLogs = true;
          ProtectHostname = true;
          ProtectClock = true;
        }
      ];
      Install.WantedBy = ["default.target"];
    };
  };
}
