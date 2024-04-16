{fetchFromGitHub}: {
  vc-intrinsics = fetchFromGitHub {
    owner = "intel";
    repo = "vc-intrinsics";
    rev = "f9c34404d0ea9abad83875a10bd48d88cea90ebd";
    hash = "sha256-F2GR3TDUUiygEhdQN+PsMT/CIYBATMQX5wkvwrziS2E=";
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
    rev = "ef7608b463298b881bc82eae4f45a4385ed74fca";
    hash = "sha256-5URdyIrJKilRmwQd9ajYgULRTCT1xXmJZbHcCl2EfbM=";
  };
  unified-runtime = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "unified-runtime";
    rev = "6ccaf38708cfa614ab7f9b34c351826cd74028f2";
    hash = "sha256-Gcuh9mzV7X6yWqWmYYdhtySBySVVrxNEMChcrobg38c=";
  };
  unified-memory-framework = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "unified-memory-framework";
    rev = "9bf7a0dc4dff76844e10edbb5c6e9d917536ef6d";
    hash = "sha256-2yJqZXpqI/dEP+movt8h0hyFgxxPNuQ9lIjNa8+X6Ns=";
  };
}
