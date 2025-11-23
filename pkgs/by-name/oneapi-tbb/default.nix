{
  lib,
  clangStdenv,
  fetchFromGitHub,
  cmake,
}:
clangStdenv.mkDerivation rec {
  pname = "oneapi-tbb";
  version = "2022.3.0";

  outputs = ["out" "dev"];

  src = fetchFromGitHub {
    owner = "uxlfoundation";
    repo = "oneTBB";
    rev = "v${version}";
    hash = "sha256-HIHF6KHlEI4rgQ9Epe0+DmNe1y95K9iYa4V/wFnJfEU=";
  };

  # Fix undefined reference errors with version script under LLVM.
  NIX_LDFLAGS = "--undefined-version";

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "oneAPI Thread Building Blocks C++ Library";
    homepage = "http://threadingbuildingblocks.org/";
    license = licenses.asl20;
    longDescription = ''
      oneTBB is a flexible C++ library that simplifies the work of adding parallelism to complex applications,
      even if you are not a threading expert.
      The library lets you easily write parallel programs that take full advantage of the multi-core performance.
      Such programs are portable, composable and have a future-proof scalability.
      oneTBB provides you with functions, interfaces, and classes to parallelize and scale the code.
      All you have to do is to use the templates.
    '';
    platforms = platforms.unix;
    maintainers = with maintainers; [thoughtpolice tmarkus];
  };
}
