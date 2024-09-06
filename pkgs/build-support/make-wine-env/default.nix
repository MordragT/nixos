{
  lib,
  stdenv,
  wineWowPackages,
  dxvk,
  nuenv,
  fuse-overlayfs,
  xvfb-run,
}: {
  pname,
  version ? lib.getVersion wine,
  wine ? wineWowPackages.full,
  arch ? 64,
  registry ? [],
}: let
  regAdd = entry: "xvfb-run ${wine}/bin/wine reg add '${entry.path}' /v '${entry.key}' /t '${entry.type}' /d '${entry.value}'\n";
  wineArch = "win${toString arch}";
in
  stdenv.mkDerivation {
    inherit pname version;

    nativeBuildInputs = [wine xvfb-run];

    buildCommand = ''
      export HOME="$(mktemp -d)"
      export WINEPREFIX=$out
      export WINEARCH=${wineArch}

      mkdir $out

      xvfb-run ${wine}/bin/wineboot --init
      wineserver --wait

      COLUMNS=100 ${dxvk}/bin/setup_dxvk.sh install --symlink
      ${lib.concatMapStrings regAdd registry}
    '';

    passthru = {
      inherit wine wineArch;
    };
  }
