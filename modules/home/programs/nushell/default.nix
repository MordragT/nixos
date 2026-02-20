{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mordrag.programs.nushell;
  plugins = [
    "${pkgs.nushellPlugins.formats}/bin/nu_plugin_formats"
    "${pkgs.nushellPlugins.gstat}/bin/nu_plugin_gstat"
    # broken https://github.com/nushell/nushell/issues/17510: "${pkgs.nu-plugin-apt}/bin/nu_plugin_apt"
  ];
in
{
  options.mordrag.programs.nushell = {
    enable = lib.mkEnableOption "Nushell";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
        # enableNushellIntegration = false;
      };

      # starship = {
      #   enable = true;
      #   enableNushellIntegration = true;
      # };

      nushell = {
        enable = true;
        package = pkgs.nushell;
        loginFile.text = ''
          # Remove each plugin
          plugin list | get name | each {|x| (plugin rm $x)}

          ${lib.concatStringsSep "\n" (lib.forEach plugins (plugin: "plugin add ${plugin}"))}
        '';
        envFile.source = ./env.nu;
        configFile.text = ''
          plugin use formats
          plugin use gstat
          # plugin use apt

          const scripts = "${./scripts}"

          # cannot use files directly as that would rename them to a hash
          # and would clash with nushell module system
          use $"($scripts)/comma.nu" ,
          use $"($scripts)/compress-pdf.nu" "compress pdf"

          alias comojit = comoji commit
          alias r = direnv reload
          alias code = zeditor

          $env.config = {
            display_errors: {
              exit_code: false
            }

            error_style: "fancy"

            ls: {
              clickable_links: true
              use_ls_colors: true
            }

            rm: {
              always_trash: true
            }

            show_banner: false

            table: {
              mode: rounded
              show_empty: true
            }
          }
        '';
      };
    };

    # vpnctl
    home.packages = with pkgs; [
      vpnctl
      superview
      all-to
    ];
  };
}
