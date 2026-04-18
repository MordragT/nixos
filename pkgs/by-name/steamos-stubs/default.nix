{ stdenv }:
stdenv.mkDerivation {
  name = "steamos-stubs";

  # TODO: Check what kind of exit code is required for stubs
  # steamos-stub-0    ->    exit-code 0
  # steamos-stub-1    ->    exit-code 1
  # ...
  buildCommand = ''
    install -D -m 755 ${./steamos-stub-0} $out/bin/jupiter-biosupdate
    install -D -m 755 ${./steamos-stub-0} $out/bin/jupiter-check-support
    install -D -m 755 ${./steamos-stub-0} $out/bin/jupiter-controller-update
    install -D -m 755 ${./steamos-stub-0} $out/bin/jupiter-initial-firmware-update

    install -D -m 755 ${./steamos-stub-0} $out/bin/steamos-polkit-helpers/jupiter-biosupdate
    install -D -m 755 ${./steamos-stub-0} $out/bin/steamos-polkit-helpers/jupiter-check-support
    install -D -m 755 ${./jupiter-dock-updater} $out/bin/steamos-polkit-helpers/jupiter-dock-updater

    install -D -m 755 ${./steamos-stub-0} $out/bin/steamos-factory-reset-config
    install -D -m 755 ${./steamos-stub-0} $out/bin/steamos-firmware-update
    install -D -m 755 ${./steamos-stub-0} $out/bin/steamos-format-device
    install -D -m 755 ${./steamos-reboot} $out/bin/steamos-reboot
    install -D -m 755 ${./steamos-stub-0} $out/bin/steamos-reset-tool
    install -D -m 755 ${./steamos-select-branch} $out/bin/steamos-select-branch
    install -D -m 755 ${./steamos-session-select} $out/bin/steamos-session-select
    install -D -m 755 ${./steamos-stub-0} $out/bin/steamos-trim-devices
    install -D -m 755 ${./steamos-update} $out/bin/steamos-update
  '';
}
