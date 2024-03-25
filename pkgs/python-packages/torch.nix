{
  pytorch,
  fetchFromGitHub,
}: (pytorch.overrideAttrs (old: rec {
  version = "2.1.0a0";

  PYTORCH_BUILD_VERSION = version;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "pytorch";
    rev = "209f2fa8ff86652f67d75c2f19bf9cb9942fd018";
    # hash = "sha256-0BpGhi/ZKSOFXYmFrHoqPc5/P9X/cHNm+z3Q0CeoX34=";
    hash = "sha256-BJpLX5jOE8ICWM4eMd88uqD6wDh9ehVQu6LjuOiItCw=";
    fetchSubmodules = true;
  };

  patches =
    [
      ./torch-patches/0001-Add-API-for-intel-XPU-to-register-new-tensor-type.patch
      ./torch-patches/0002-Add-xpu-legacy-profiler-163.patch
      ./torch-patches/0003-add-custom-pass-hooks-in-post_grad_passes-164.patch
      ./torch-patches/0004-Add-qweight-prepack-runtime-registration-linear-conv.patch
      ./torch-patches/0005-fix-hpu-deserialization-bug-165.patch
      ./torch-patches/0006-C10d-Add-xpu-as-the-supported-device-in-device-backe.patch
      ./torch-patches/0007-add-path-for-DPC-SYCL-device-code-167.patch
      ./torch-patches/0008-generalize-inductor-triton-backend-device-agnostic-1.patch
      ./torch-patches/0009-Integrate-xpu-into-torch.Generator-and-torch.seed-10.patch
      ./torch-patches/0010-Enable-xpu-backend-in-torchdynamo-benchmarks-171.patch
      ./torch-patches/0011-support-channel-last-for-xpu-conv-in-inductor-layout.patch
      ./torch-patches/0012-Cherry-pick-https-github.com-pytorch-pytorch-pull-10.patch
      ./torch-patches/0013-Inductor-backend-specific-num-sm-for-XPU-backend-in-.patch
      ./torch-patches/0014-ATen-scaled_dot_product_attention-follow-supposed-CU.patch
      ./torch-patches/0015-Profiler-Kineto-Legacy-Enable-Profiler-with-Legacy-K.patch
      ./torch-patches/0016-Fix-dynamo-benchmark-random-seed-for-xpu-device-181.patch
      ./torch-patches/0017-fix-deterministic-issue-200.patch
    ]
    ++ old.patches;
}))
