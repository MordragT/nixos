{
  stdenv,
  fetchFromGitHub,
  fetchzip,
  cmake,
  vulkan-headers,
  vulkan-loader,
  glslang,
}:
stdenv.mkDerivation rec {
  pname = "upscayl-ncnn";
  version = "20240601-103425";

  src =
    (fetchFromGitHub {
      owner = "upscayl";
      repo = pname;
      rev = version;
      hash = "sha256-EsDi6P1OI/bCw5R9FDOZafeAwysYB8kQck2ndy6cofs=";
      fetchSubmodules = true;
    })
    # https://github.com/NixOS/nixpkgs/issues/195117#issuecomment-1410398050
    .overrideAttrs (_: {
      GIT_CONFIG_COUNT = 1;
      GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
      GIT_CONFIG_VALUE_0 = "git@github.com:";
    });

  sourceRoot = "${src.name}/src";

  models = fetchzip {
    url = "https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.5.0/realesrgan-ncnn-vulkan-20220424-ubuntu.zip";
    sha256 = "sha256-1YiPzv1eGnHrazJFRvl37+C1F2xnoEbN0UQYkxLT+JQ=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    vulkan-headers
    vulkan-loader
    glslang
  ];

  installPhase = ''
    mkdir -p $out/bin $out/bin/models
    cp upscayl-bin $out/bin/
    cp  -r ${models}/models/* $out/bin/models
  '';
}
