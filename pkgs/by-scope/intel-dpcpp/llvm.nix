{
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  level-zero,
  intel-tbb,
  ocl-icd,
  zlib,
  libxml2,
  libffi_3_3,
  elfutils,
  unified-memory-framework,
  lib,
}:
let
  pins = builtins.fromJSON (builtins.readFile ./default.lock);
  version = "2025.3";

  srcs = builtins.mapAttrs fetchurl pins;
in
stdenvNoCC.mkDerivation {
  inherit version;
  pname = "intel-dpcpp";

  # dontUnpack = true;
  dontStrip = true;

  outputs = [
    "out"
    "lib"
    "dev"
    "rsrc"
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    intel-tbb
    stdenv.cc.cc.lib
    level-zero
    zlib
    libxml2
    libffi_3_3
    elfutils
    ocl-icd
    unified-memory-framework
  ];

  unpackPhase = lib.concatMapAttrsStringSep "\n" (_name: src: "dpkg-deb -x ${src} .") srcs;

  installPhase = ''
    cd ./opt/intel/oneapi/compiler/${version}

    mv lib/clang/21 $rsrc

    mkdir $out
    mv bin $out/bin
    mv env $out/env
    mv etc/compiler $out/env/compiler
    mv share $out/share

    mkdir $dev
    mv include $dev/include
    mv opt/compiler/include $dev/include/compiler
    mkdir $dev/lib
    mv lib/pkgconfig $dev/lib/pkgconfig
    mv lib/cmake $dev/lib/cmake
    sed -r -i "s|^prefix=.*|prefix=$lib|g" $dev/lib/pkgconfig/openmp.pc

    mkdir $lib
    mv lib $lib/lib
    mv opt/compiler/lib $lib/lib/compiler
    # remove libopencl to link against patched opencl-loader from nixos
    rm $lib/lib/libOpenCL.so*
    rm $lib/lib/libhwloc.so*
    rm $lib/lib/libtcm*
  '';
}
