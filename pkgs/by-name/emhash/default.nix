{
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "emhash";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "ktprime";
    repo = "emhash";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dFj/QaGdTJYdcxKlS9tES6OHae8xPMnrG9ccRNM/hi8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DWITH_BENCHMARKS=Off"
  ];
})
