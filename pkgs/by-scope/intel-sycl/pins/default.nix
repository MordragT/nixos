{
  fetchFromGitHub,
  applyPatches,
}: {
  vc-intrinsics = fetchFromGitHub {
    owner = "intel";
    repo = "vc-intrinsics";
    rev = "dpcpp_staging";
    hash = "sha256-sbmLl+bOOMwr/tbtnXt19qIT3qmrCw7SLefZ4/gEsYw=";
  };
  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "efb6b4099ddb8fa60f62956dee592c4b94ec6a49";
    hash = "sha256-07ROnZ+0xrZRoqUbLJAhqERV3X8E6iBEfMYfhWMfuyA=";
  };
  ocl-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-Headers";
    rev = "542d7a8f65ecfd88b38de35d8b10aa67b36b33b2";
    hash = "sha256-LgpDEXiFiYDrRTKc5M5RK+2DrPx5ve44P41P9/sHkzE=";
  };
  ocl-loader = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-ICD-Loader";
    rev = "804b6f040503c47148bee535230070da6b857ae4";
    hash = "sha256-tl4qtBwzfpR1gR+qEFyM/zdDzHVpVhbo3PCfbj95q/0=";
  };
  mp11 = fetchFromGitHub {
    owner = "boostorg";
    repo = "mp11";
    rev = "863d8b8d2b20f2acd0b5870f23e553df9ce90e6c";
    hash = "sha256-yvK4F4Z+cr5YdORzLRgL+LyeKwvpY2MBynPIDFRATS0=";
  };
  unified-runtime = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "unified-runtime";
    rev = "b7047f6c36ec17b8560c2f1cd9ac9521715a9127";
    hash = "sha256-AtHvwvcVy5JvJqqT7hFMze1OqtgEzk+c5lSnIAaRaSo=";
  };

  # unified-runtime = applyPatches {
  #   src = fetchFromGitHub {
  #     owner = "oneapi-src";
  #     repo = "unified-runtime";
  #     rev = "b7047f6c36ec17b8560c2f1cd9ac9521715a9127";
  #     hash = "sha256-AtHvwvcVy5JvJqqT7hFMze1OqtgEzk+c5lSnIAaRaSo=";
  #   };
  #   patches = [
  #     ./umf.patch
  #   ];
  # };
  # unified-memory-framework = fetchFromGitHub {
  #   owner = "oneapi-src";
  #   repo = "unified-memory-framework";
  #   rev = "85e3bd72dbaa95e9e5fd2a4a787714b7cf1c6a16";
  #   hash = "sha256-OMKGhVF5NMBaqPTfb722WSpOOjfR3pVUHvGj7zIXl04=";
  # };
}
