{
  stdenv,
  mkLLVM,
}:
mkLLVM {
  inherit stdenv;
  name = "xptifw";
}
