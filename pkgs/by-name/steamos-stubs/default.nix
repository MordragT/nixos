{ stdenv }:
stdenv.mkDerivation {
  name = "steamos-stubs";
  buildCommand = ''
    # Polkit Helpers used by steam
    install -D -m 755 ${./jupiter-biosupdate} $out/bin/steamos-polkit-helpers/jupiter-biosupdate
    install -D -m 755 ${./jupiter-dock-updater} $out/bin/steamos-polkit-helpers/jupiter-dock-updater

    # Steamos tools used by steam
    install -D -m 755 ${./steamos-reboot} $out/bin/steamos-reboot
    install -D -m 755 ${./steamos-select-branch} $out/bin/steamos-select-branch
    install -D -m 755 ${./steamos-session-select} $out/bin/steamos-session-select
    install -D -m 755 ${./steamos-update} $out/bin/steamos-update

    # Stubs used by stamos-manager
    install -D -m 755 ${./steamos-reset-tool} $out/bin/steamos-reset-tool
    install -D -m 755 ${./steamos-trim-devices} $out/bin/steamos-trim-devices
    install -D -m 755 ${./steamos-format-device} $out/bin/steamos-format-device

  '';
}
