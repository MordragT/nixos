{fetchFromGitHub}: {
  vc-intrinsics = fetchFromGitHub {
    owner = "intel";
    repo = "vc-intrinsics";
    rev = "60cea7590bd022d95f5cf336ee765033bd114d69";
    hash = "sha256-1K16UEa6DHoP2ukSx58OXJdtDWyUyHkq5Gd2DUj1644=";
  };
  compute-runtime = fetchFromGitHub {
    owner = "intel";
    repo = "compute-runtime";
    rev = "25.35.35096.9";
    hash = "sha256-Ta5KYEbrp71OpoU3cePKEQ4rWNYgbzjyKbKmdydTPZ0=";
    sparseCheckout = [
      "level_zero/include"
    ];
  };
}
