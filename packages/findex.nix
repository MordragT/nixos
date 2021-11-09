
{ system
, lib
, pkgs
, naersk
, fenix
}:

let
  toolchain = with fenix.packages.${system};
    combine [
      minimal.rustc
      minimal.cargo
    ];
  naersk-lib = naersk.lib.${system}.override {
    cargo = toolchain;
    rustc = toolchain;
  };
  root = pkgs.fetchFromGitHub {
    owner = "mdgaziur";
    repo = "findex";
    rev = "e19403b3d31a75d7580c1f953dd8e6cb1225c2e9";
    sha256 = "NA6qRtwChfoq4lshRL7lLQ0KyjCMHAU1a0xLFrZP6X0=";
  };
  # findex-config = pkgs.stdenv.mkDerivation {
  #   name = "findex-config";
  #   src = root + "/css/";
  #   installPhase = ''
  #     mkdir /home/tom/.config/findex/
  #     ln style.css  /home/tom/.config/findex/style.css
  #   '';
  # };
in
naersk-lib.buildPackage {
  pname = "findex";
  inherit root;
  buildInputs = with pkgs; [
    # findex-config
    pkgconfig
    cairo
    glib
    gdk-pixbuf
    gtk3
    pango
  ];
  meta = with lib; {
    description = "GTK GUI to find applications and files";
  };
}
