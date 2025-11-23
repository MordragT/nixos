{
  fetchFromGitHub,
  applyPatches,
  linkFarm,
}: {
  vc-intrinsics = fetchFromGitHub {
    owner = "intel";
    repo = "vc-intrinsics";
    rev = "60cea7590bd022d95f5cf336ee765033bd114d69";
    hash = "sha256-1K16UEa6DHoP2ukSx58OXJdtDWyUyHkq5Gd2DUj1644=";
  };
  # spirv-headers = fetchFromGitHub {
  #   owner = "KhronosGroup";
  #   repo = "SPIRV-Headers";
  #   rev = "2b2e05e088841c63c0b6fd4c9fb380d8688738d3";
  #   hash = "sha256-EZrWquud9CFrDNdskObCQQCR0HsXOZmJohh/0ybaT7g=";
  # };
  # ocl-headers = fetchFromGitHub {
  #   owner = "KhronosGroup";
  #   repo = "OpenCL-Headers";
  #   rev = "542d7a8f65ecfd88b38de35d8b10aa67b36b33b2";
  #   hash = "sha256-LgpDEXiFiYDrRTKc5M5RK+2DrPx5ve44P41P9/sHkzE=";
  # };
  # ocl-loader = fetchFromGitHub {
  #   owner = "KhronosGroup";
  #   repo = "OpenCL-ICD-Loader";
  #   rev = "804b6f040503c47148bee535230070da6b857ae4";
  #   hash = "sha256-tl4qtBwzfpR1gR+qEFyM/zdDzHVpVhbo3PCfbj95q/0=";
  # };
  # mp11 = fetchFromGitHub {
  #   owner = "boostorg";
  #   repo = "mp11";
  #   rev = "863d8b8d2b20f2acd0b5870f23e553df9ce90e6c";
  #   hash = "sha256-yvK4F4Z+cr5YdORzLRgL+LyeKwvpY2MBynPIDFRATS0=";
  # };
  # unified-runtime = applyPatches {
  #   src = fetchFromGitHub {
  #     owner = "oneapi-src";
  #     repo = "unified-runtime";
  #     rev = "d03f19a88e42cb98be9604ff24b61190d1e48727";
  #     hash = "sha256-gbOWgwFDbT/y8cXZHv6yEAP2EZvTxNeKmcY3OQsnXGA=";
  #   };
  #   patches = [
  #     ./compute-runtime.patch
  #   ];
  # };
  compute-runtime = fetchFromGitHub {
    owner = "intel";
    repo = "compute-runtime";
    rev = "25.35.35096.9";
    hash = "sha256-Ta5KYEbrp71OpoU3cePKEQ4rWNYgbzjyKbKmdydTPZ0=";
    sparseCheckout = [
      "level_zero/include"
    ];
  };
  # emhash = fetchFromGitHub {
  #   owner = "ktprime";
  #   repo = "emhash";
  #   rev = "3ba9abdfdc2e0430fcc2fd8993cad31945b6a02b";
  #   hash = "sha256-w/iW5n9BzdiieZfxnVBF5MJTpHtZoWCUomjZ0h4OGH8=";
  # };
  # move from /nix/store/<hash>-emhash-<version>/*.cpp to <version>/emhash/*.cpp
  # emhash = linkFarm "emhash" [
  #   {
  #     name = "emhash";
  #     path = fetchFromGitHub {
  #       owner = "ktprime";
  #       repo = "emhash";
  #       rev = "3ba9abdfdc2e0430fcc2fd8993cad31945b6a02b";
  #       hash = "sha256-w/iW5n9BzdiieZfxnVBF5MJTpHtZoWCUomjZ0h4OGH8=";
  #     };
  #   }
  # ];
  # parallel-hashmap = fetchFromGitHub {
  #   owner = "greg7mdp";
  #   repo = "parallel-hashmap";
  #   rev = "8a889d3699b3c09ade435641fb034427f3fd12b6";
  #   hash = "sha256-hcA5sjL0LHuddEJdJdFGRbaEXOAhh78wRa6csmxi4Rk=";
  # };
}
