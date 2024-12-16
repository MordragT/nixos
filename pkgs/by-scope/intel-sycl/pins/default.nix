{
  fetchFromGitHub,
  applyPatches,
}: {
  vc-intrinsics = fetchFromGitHub {
    owner = "intel";
    repo = "vc-intrinsics";
    rev = "b2565a03eb3cac07f5e8000fde971f95dc782c75";
    hash = "sha256-4odRQyF3wMJZWKTY/dWmb3RG4j5dP7Hvr2wo9dSfyN8=";
  };
  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "b73e168ca5e123dcf3dea8a34b19a5130f421ae1";
    hash = "sha256-GSUKyOg59w8COqDQplnsNyosEvbG8ZpG2tF9ysgGkXo=";
  };
  ocl-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-Headers";
    rev = "9ddb236e6eb3cf844f9e2f81677e1045f9bf838e";
    hash = "sha256-z4lNan3kr+WIVjGxFcFMSbdVMbiqmv5K842k+onEPJA=";
  };
  ocl-loader = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-ICD-Loader";
    rev = "9a3e962f16f5097d2054233ad8b6dad51b6f41b7";
    hash = "sha256-ScQ6Duj2lyUoW5z9xtRVvggD+5qCAq/Ou/Dj5Pkf4S4=";
  };
  mp11 = fetchFromGitHub {
    owner = "boostorg";
    repo = "mp11";
    rev = "863d8b8d2b20f2acd0b5870f23e553df9ce90e6c";
    hash = "sha256-yvK4F4Z+cr5YdORzLRgL+LyeKwvpY2MBynPIDFRATS0=";
  };
  unified-runtime = applyPatches {
    src = fetchFromGitHub {
      owner = "oneapi-src";
      repo = "unified-runtime";
      rev = "b0c64c8154a4b6ddf2442d944239e3d5e5ebda82";
      hash = "sha256-A0BG7Us9Z8SLBSrdV5yexXV/XSk9mOWyvPqn9alOAJw=";
    };
    patches = [
      ./umf.patch
    ];
  };
  unified-memory-framework = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "unified-memory-framework";
    rev = "85e3bd72dbaa95e9e5fd2a4a787714b7cf1c6a16";
    hash = "sha256-OMKGhVF5NMBaqPTfb722WSpOOjfR3pVUHvGj7zIXl04=";
  };
}
