{
  mkLLVM,
  stdenv,
}:
mkLLVM {
  inherit stdenv;
  name = "xpti";

  extraBuildInputs = [
  ];
}
