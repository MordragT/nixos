{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.programs.steam;

  # https://developer.valvesoftware.com/wiki/Steam_Library_Shortcuts
  writeVdfShortcuts =
    pkgs.writers.writePython3 "create-shortcuts.py" { libraries = [ pkgs.python3Packages.vdf ]; }
      ''
        import binascii
        import json
        import sys
        import ctypes

        import vdf

        with open(sys.argv[1]) as fp:
            shortcuts = json.load(fp)


        def make_entry(i, s):
            exe = s["exe"]
            app = s["name"]
            args = s.get("args", [])
            envs = s.get("environment", {})

            if s.get("app_id") is not None:
                app_id = s["app_id"]
            else:
                combined = (app + exe + "\x00").encode("latin-1")
                raw = binascii.crc32(combined) | 0x80000000
                app_id = ctypes.c_int32(raw & 0xFFFFFFFF).value

            env_str = " ".join(f"{k}={v}" for k, v in envs.items())
            args_str = " ".join(args)
            launch_opts = f"{env_str} {args_str}".strip()

            return {
                "appid": app_id,
                "appname": app,
                "Exe": f"\"{exe}\"",
                "LaunchOptions": launch_opts,
                "AllowOverlay": 0,
            }


        data = {
            "shortcuts": {str(i): make_entry(i, s) for i, s in enumerate(shortcuts)}
        }

        with open(sys.argv[2], "wb") as fp:
            vdf.binary_dump(data, fp)
      '';

  createShortcutsVdf =
    shortcuts:
    pkgs.runCommand "shortcuts.vdf" {
      shortcuts = builtins.toJSON shortcuts;
      passAsFile = [ "shortcuts" ];
    } "${writeVdfShortcuts} $shortcutsPath $out";
in
{
  options.mordrag.programs.steam = {
    enable = lib.mkEnableOption "Steam";

    compatPackages = lib.mkOption {
      description = "Enable compatibility tools";
      type = with lib.types; listOf package;
      default = [ ];
    };

    shortcuts = lib.mkOption {
      description = "List of shortcuts to create in steam";
      default = [ ];
      type =
        with lib.types;
        listOf (submodule {
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              description = "Name of the shortcut";
            };

            app_id = lib.mkOption {
              description = ''
                AppID to use for the shortcut.
                If not set, it will be generated based on the name and exe.
              '';
              type = with lib.types; nullOr int;
              default = null;
            };

            environment = lib.mkOption {
              type = with lib.types; attrsOf str;
              description = "Environment variables to set when launching";
              default = { };
            };

            exe = lib.mkOption {
              type = lib.types.path;
              description = "Path to the executable";
            };

            args = lib.mkOption {
              type = with lib.types; listOf str;
              description = "Arguments to pass to the executable";
              default = [ ];
            };
          };
        });
    };
  };

  config = lib.mkIf cfg.enable {
    mordrag.users.main = {
      extraGroups = [ "gamemode" ];
      xdg.dataFile."Steam/userdata/100029185/config/shortcuts.vdf".source =
        createShortcutsVdf cfg.shortcuts;
    };

    hardware.steam-hardware.enable = true;

    programs = {
      steam = {
        enable = true;
        protontricks.enable = true;
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        dedicatedServer.openFirewall = false;
        extraCompatPackages = cfg.compatPackages;
      };
      gamemode = {
        enable = true;
        enableRenice = true;
        settings.general = {
          renice = 10;
          inhibit_screensaver = 0;
        };
      };
    };
    environment.etc = {
      # Crusader Kings 3
      "ssl/certs/f387163d.0".source = "${pkgs.cacert.unbundled}/etc/ssl/certs/Starfield_Class_2_CA.crt";
    };
  };
}
