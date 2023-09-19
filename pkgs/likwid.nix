{
  stdenv,
  lib,
  fetchFromGitHub,
  perl,
  clang,
  gnumake,
}:
stdenv.mkDerivation {
  pname = "likwid";
  version = "master";

  src = fetchFromGitHub {
    sha256 = "lH2CRka/d6o8xfu72O+ZwbzHghypy0Ipk95xgy0Xo/k=";
    rev = "a4116cdac104ee9560970093731cfa991f6a6d5e";
    owner = "RRZE-HPC";
    repo = "likwid";
  };

  buildInputs = [
    perl
    clang
  ];

  nativeBuildInputs = [gnumake];

  hardeningDisable = ["format"];

  preBuild = ''
    	substituteInPlace config.mk --replace 'PREFIX ?= /usr/local' "PREFIX ?= $out" --replace "ACCESSMODE = accessdaemon" "ACCESSMODE = perf_event"
    	substituteInPlace perl/gen_events.pl --replace '/usr/bin/env perl' '${perl}/bin/perl'
    	substituteInPlace bench/perl/generatePas.pl --replace '/usr/bin/env perl' '${perl}/bin/perl'
    	substituteInPlace bench/perl/AsmGen.pl --replace '/usr/bin/env perl' '${perl}/bin/perl'
    substituteInPlace Makefile --replace '@install -m 4755 $(INSTALL_CHOWN)' '#@install -m 4755 $(INSTALL_CHOWN)'
  '';

  meta = with lib; {
    description = "Performance monitoring and benchmarking suite ";
    longDescription = ''
      Likwid is a simple to install and use toolsuite of command line applications and a library for performance oriented programmers.
      It works for Intel, AMD, ARMv8 and POWER9 processors on the Linux operating system.
      There is additional support for Nvidia GPUs.
      There is support for ARMv7 and POWER8 but there is currently no test machine in our hands to test them properly.
    '';
    homepage = "https://hpc.fau.de/research/tools/likwid/";
    license = [licenses.gpl3];
    platforms = platforms.unix;
    maintainers = with maintainers; [mordrag];
  };
}
