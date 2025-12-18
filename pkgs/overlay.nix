self: pkgs: let
  pins = import ./pins.nix {inherit (pkgs.stdenv.hostPlatform) system;};
  build-support = import ./build-support self pkgs;
  by-name = import ./by-name self pkgs;
  by-scope = import ./by-scope self pkgs;
in
  pkgs.lib.mergeAttrsList [
    by-name
    by-scope
    build-support
    {
      # stirling-pdf = pins.stirling-pdf.stirling-pdf;
      invokeai = with self.intel-python.pkgs; toPythonApplication invokeai;

      marker-pdf = with self.intel-python.pkgs; toPythonApplication marker-pdf;

      steamtinkerlaunch = pkgs.steamtinkerlaunch.overrideAttrs (old: {
        # Prepare the proper files for the steam compatibility toolchain
        postInstall =
          old.postInstall
          + ''
            cat > $out/bin/compatibilitytool.vdf << EOF
            "compatibilitytools"
            {
              "compat_tools"
              {
                "steamtinkerlaunch" // Internal name of this tool
                {
                  "install_path" "."
                  "display_name" "Steam Tinker Launch"

                  "from_oslist"  "windows"
                  "to_oslist"    "linux"
                }
              }
            }
            EOF

            cat > $out/bin/toolmanifest.vdf << EOF
            "manifest"
            {
              "commandline" "/steamtinkerlaunch run"
              "commandline_waitforexitandrun" "/steamtinkerlaunch waitforexitandrun"
            }
            EOF
          '';
      });
    }
  ]
