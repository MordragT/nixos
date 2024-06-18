{
  lib,
  stdenv,
  fetchurl,
}: rec {
  mkXpiAddon = addon:
    stdenv.mkDerivation {
      inherit (addon) version;

      pname = addon.name;
      src = fetchurl {
        inherit (addon) url sha256;
      };

      preferLocalBuild = true;
      allowSubstitutes = true;

      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addon.addonId}.xpi"
      '';

      meta = {
        inherit (addon) homepage description;
        license = lib.getLicenseFromSpdxId addon.license;
        platforms = lib.platforms.all;
      };
    };

  mkXpiAddonsFromList = list: lib.mergeAttrsList (builtins.map (addon: {"${addon.slug}" = mkXpiAddon addon;}) list);
}
