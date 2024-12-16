{
  stdenv,
  fetchFromGitHub,
  cmake,
  libdrm,
  lib,
}:
stdenv.mkDerivation (self: {
  pname = "metrics-discovery";
  version = "1.13.179";

  src = fetchFromGitHub {
    owner = "intel";
    repo = self.pname;
    rev = "${self.pname}-${self.version}";
    hash = "sha256-RmLFPW9DOp4KMIY8jEHsNuxgV9Qhi1encX71AnqzOtY=";
  };

  nativeBuildInputs = [cmake];

  buildInputs = [libdrm.dev];

  meta = {
    description = "User mode library that provides access to GPU performance data.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [mordrag];
    platforms = lib.platforms.linux;
  };
})
