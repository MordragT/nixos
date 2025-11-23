{
  stdenv,
  fetchFromGitHub,
  cmake,
  libdrm,
  lib,
}:
stdenv.mkDerivation (self: {
  pname = "metrics-discovery";
  version = "1.14.182";

  src = fetchFromGitHub {
    owner = "intel";
    repo = self.pname;
    rev = "${self.pname}-${self.version}";
    hash = "sha256-AgrCJR10B1rtk/VLx7k5I3A4ZVhHoF3p4oxyiY4yAnI=";
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
