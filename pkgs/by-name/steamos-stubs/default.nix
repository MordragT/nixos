{ stdenv }:
stdenv.mkDerivation {
  name = "steamos-stubs";

  buildCommand = ''
    install -D -m 755 ${./steamos-stub} $out/bin/steamos-bios-update
    install -D -m 755 ${./steamos-stub} $out/bin/steamos-dock-updater
    install -D -m 755 ${./steamos-stub} $out/bin/steamos-factory-reset-config
    install -D -m 755 ${./steamos-stub} $out/bin/steamos-firmware-update
    install -D -m 755 ${./steamos-stub} $out/bin/steamos-format-device
    install -D -m 755 ${./steamos-reboot} $out/bin/steamos-reboot
    install -D -m 755 ${./steamos-stub} $out/bin/steamos-reset-tool
    install -D -m 755 ${./steamos-select-branch} $out/bin/steamos-select-branch
    install -D -m 755 ${./steamos-session-select} $out/bin/steamos-session-select
    install -D -m 755 ${./steamos-stub} $out/bin/steamos-trim-devices
    install -D -m 755 ${./steamos-update} $out/bin/steamos-update
  '';
}
