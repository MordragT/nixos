{
  lib,
  fetchurl,
  unzip,
  autoPatchelfHook,
  intel-dpcpp,
  level-zero,
}:
let
  version = "0.17.0";
in
intel-dpcpp.stdenv.mkDerivation {
  pname = "intel-pti";
  inherit version;

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/0b/02/798ea3cb0189b66cef0fc95d9b36f43df740714997f5e0976e074274a270/intel_pti-${version}-py2.py3-none-manylinux_2_28_x86_64.whl";
    hash = "sha256-GjMnuGg69y5g4eqPdUFg+xL/uKFeV5QffjZyvMVA4vw=";
  };

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
  ];

  buildInputs = [
    intel-dpcpp.llvm.lib
    level-zero
  ];

  unpackPhase = ''
    runHook preUnpack
    unzip -q $src -d wheel
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib $out/etc $out/share
    cp -a wheel/intel_pti-${version}.data/data/lib/* $out/lib/
    cp -a wheel/intel_pti-${version}.data/data/etc/* $out/etc/
    cp -a wheel/intel_pti-${version}.data/data/share/* $out/share/
    runHook postInstall
  '';

  dontStrip = true;

  meta = {
    description = "Intel Profiling Tools Interface (PTI) shared libraries";
    homepage = "https://github.com/intel/pti-gpu";
    license = with lib.licenses; [
      mit
      asl20
    ];
    platforms = [ "x86_64-linux" ];
  };
}
