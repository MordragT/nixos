{pkgs}: let
  intel = import ./intel {inherit pkgs;};
  llvm = import ./llvm {inherit pkgs;};
  oneapi = import ./oneapi {inherit pkgs intel;};
  python = import ./python {inherit pkgs intel oneapi;};
in
  intel // llvm // oneapi // python
