{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  cmake,
  python3,
  openvino,
  onetbb,
}:
let
  sentencepiece = fetchFromGitHub {
    owner = "google";
    repo = "sentencepiece";
    rev = "v0.2.0";
    hash = "sha256-tMt6UBDqpdjAhxAJlVOFFlE3RC36/t8K0gBAzbesnsg=";
  };
  fast-tokenizer = fetchzip {
    url = "https://bj.bcebos.com/paddlenlp/fast_tokenizer/fast_tokenizer-linux-x64-1.0.2.tgz";
    hash = "sha256-lvxgdosW3PIKvYCU/xXpabYw3l2CvdYYVV1lYbjYpFc=";
  };
  pcre2 = fetchFromGitHub {
    owner = "PCRE2Project";
    repo = "pcre2";
    rev = "pcre2-10.44";
    hash = "sha256-u3OvEGhUaiC8G7s3ze0D4QGgRLfmAKhr4r5NAAD3nks=";
  };
in
stdenv.mkDerivation (self: {
  pname = "openvino-tokenizers";
  version = "2024.5.0.0";

  src = fetchFromGitHub {
    owner = "openvinotoolkit";
    repo = "openvino_tokenizers";
    rev = "${self.version}";
    hash = "sha256-xi7ngCOD9/qEmC6v0+XbaPqX2yoDeTbW8w+0FXVahV8=";
  };

  outputs = [
    "out"
    "python"
  ];

  cmakeFlags = [
    "-DOpenVINO_DIR=${openvino}/runtime/cmake"
    "-DFETCHCONTENT_SOURCE_DIR_SENTENCEPIECE=${sentencepiece}"
    "-DFETCHCONTENT_SOURCE_DIR_FAST_TOKENIZER=${fast-tokenizer}"
    "-DFETCHCONTENT_SOURCE_DIR_PRCE2=${pcre2}"
    "-DENABLE_PYTHON=ON"
  ];

  nativeBuildInputs = [
    cmake
    python3
  ];

  buildInputs = [
    openvino
    onetbb
  ];

  postInstall = ''
    cp -r $src/python $python
  '';

  # postInstall = ''
  #   mkdir -p $python
  #   mv python/* $python/
  # '';

  # postInstall = ''
  #   mkdir -p $python

  #   cp -r $src/python/* $python/
  #   rm $python/openvino_tokenizers/__version__.py
  #   mv python/__version__.py $python/openvino_tokenizers/__version__.py
  # '';

  meta = {
    description = "OpenVINO Tokenizers extension";
    homepage = "https://github.com/openvinotoolkit/openvino_tokenizers/tree/main";
    changelog = "https://github.com/openvinotoolkit/openvino_tokenizers/releases/tag/${self.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mordrag ];
  };
})
