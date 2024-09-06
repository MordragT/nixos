{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.programs.nushell;
in {
  options.mordrag.programs.nushell = {
    enable = lib.mkEnableOption "Nushell";
  };

  config = lib.mkIf cfg.enable {
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    # programs.direnv.enableNushellIntegration = false;

    # programs.starship.enable = true;
    # programs.starship.enableNushellIntegration = true;

    programs.nushell = {
      enable = true;
      package = pkgs.nushell;
      configFile.text = ''
        plugin add "${pkgs.nushellPlugins.formats}/bin/nu_plugin_formats"
        plugin add "${pkgs.nushellPlugins.gstat}/bin/nu_plugin_gstat"
        plugin add "${pkgs.nu-plugin-apt}/bin/nu_plugin_apt"

        plugin use formats
        plugin use gstat
        plugin use apt

        const scripts = "${./scripts}"
        $env.CERTIFICATES = "${./scripts/vpnctl}"

        # cannot use files directly as that would rename them to a hash
        # and would clash with nushell module system
        use $"($scripts)/comma.nu" ,
        use $"($scripts)/vpnctl"
        use $"($scripts)/all-to.nu"
        use $"($scripts)/superview.nu"

        # alias code = codium
        alias comojit = comoji commit
        alias r = direnv reload

        $env.config = {
          show_banner: false

          ls: {
            use_ls_colors: true
            clickable_links: true
          }

          rm: {
            always_trash: true
          }

          table: {
            mode: rounded
            show_empty: true
          }

          error_style: "fancy"
        }
      '';
    };

    # vpnctl
    home.packages = with pkgs; [
      openconnect
      wireguard-tools
    ];
  };
}
