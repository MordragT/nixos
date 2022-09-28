{ buildGoApplication, fetchFromGitHub, pkg-config, ffmpeg, binutils, libGL, xorg }:
let
  src = fetchFromGitHub {
    owner = "Niek";
    repo = "superview";
    rev = "f23ea5cd72fd21a5994599c8f440e6c5468ed323";
    sha256 = "gN5pX0QgJhYExXPQ8Y72xwMoapWrjnIBOiL6c8byz4E=";
  };
in
buildGoApplication {
  inherit src;
  pname = "superview";
  version = "0.10";

  PKG_CONFIG_PATH = "${libGL.dev}/lib/pkgconfig";
  C_INCLUDE_PATH = "${xorg.libX11.dev}/include:${libglvnd.dev}/include:${xorg.xorgproto}/include:${xorg.libXcursor.dev}/include:${xorg.libXrandr.dev}/include:${xorg.libXrender.dev}/include:${xorg.libXinerama.dev}/include:${xorg.libXi.dev}/include:${xorg.libXext.dev}/include:${xorg.libXfixes.dev}/include";
  LD_LIBRARY_PATH = "${xorg.libX11}/lib:${xorg.libXrandr}/lib:${xorg.libXxf86vm}:${xorg.libXi}/lib:${xorg.libXcursor}/lib";

  nativeBuildInputs = [
    pkg-config
    ffmpeg
    binutils
    libGL
    xorg.libX11
    xorg.libXrandr
    xorg.libXxf86vm
    xorg.libXi
    xorg.libXcursor
  ];

  pwd = ./.;
  modules = ./superview.toml;
}
