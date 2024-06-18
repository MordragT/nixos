self: pkgs: let
  intel = import ./intel self pkgs;
  oneapi = import ./oneapi self pkgs;
in
  pkgs.lib.mergeAttrsList [
    intel
    oneapi
  ]
