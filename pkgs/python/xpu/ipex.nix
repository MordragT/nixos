{
  buildPythonPackage,
  fetchurl,
  expecttest,
  hypothesis,
  numpy,
  psutil,
  pytest,
  pyyaml,
  scipy,
  # types-dataclasses,
  typing-extensions,
  pydantic,
  torch,
  addOpenGLRunpath,
  autoPatchelfHook,
  level-zero,
  xpuPackages,
  zstd,
}:
buildPythonPackage {
  pname = "intel-extension-for-pytorch";
  version = "2.1.10+xpu";
  format = "wheel";

  src = fetchurl {
    url = "https://intel-extension-for-pytorch.s3.amazonaws.com/ipex_stable/xpu/intel_extension_for_pytorch-2.1.10%2Bxpu-cp311-cp311-linux_x86_64.whl";
    sha256 = "sha256-LX3TvEGM5BbPw/nkOhaTq6v+nduTI68y2WFhNw25VSI=";
  };

  nativeBuildInputs = [
    addOpenGLRunpath
    autoPatchelfHook
  ];

  buildInputs = [
    level-zero
    xpuPackages.oneMKL
    xpuPackages.dpcpp-cpp
    zstd
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libOpenCL.so.1"
  ];

  propagatedBuildInputs = [
    expecttest
    hypothesis
    numpy
    psutil
    pytest
    pyyaml
    scipy
    # types-dataclasses
    typing-extensions
    pydantic
    torch
  ];
}
# libtorch.so -> found: /nix/store/palk1ckdb5hlyxiy2gsyz221a3655agq-python3.11-torch-2.1.2-lib/lib
# libtorch_cpu.so -> found: /nix/store/palk1ckdb5hlyxiy2gsyz221a3655agq-python3.11-torch-2.1.2-lib/lib
# libc10.so -> found: /nix/store/palk1ckdb5hlyxiy2gsyz221a3655agq-python3.11-torch-2.1.2-lib/lib
# libxetla_kernels.so -> found: /nix/store/snx3hlh7rw9gdahndzz4r112n5kp9ada-python3.11-intel-extension-for-pytorch-2.1.10+xpu/lib/python3.11/site-packages/intel_extension_for_pytorch/lib
# libmkl_intel_lp64.so.2 -> found: /nix/store/b58bhlarq1630f8ccf73fnp2l5qnm89y-mkl-2023.1.0.46342/lib
# libmkl_core.so.2 -> found: /nix/store/b58bhlarq1630f8ccf73fnp2l5qnm89y-mkl-2023.1.0.46342/lib
# libmkl_gnu_thread.so.2 -> found: /nix/store/b58bhlarq1630f8ccf73fnp2l5qnm89y-mkl-2023.1.0.46342/lib
# libmkl_sycl_blas.so.4 -> not found!
# libmkl_sycl_lapack.so.4 -> not found!
# libmkl_sycl_sparse.so.4 -> not found!
# libmkl_sycl_dft.so.4 -> not found!
# libmkl_sycl_vm.so.4 -> not found!
# libmkl_sycl_rng.so.4 -> not found!
# libmkl_sycl_stats.so.4 -> not found!
# libmkl_sycl_data_fitting.so.4 -> not found!
# libze_loader.so.1 -> found: /nix/store/ivagyaq6d6vfchm01ncm0h6pgb4rpypc-level-zero-1.15.8/lib
# libOpenCL.so.1 -> not found!
# libsvml.so -> not found!
# libirng.so -> not found!
# libstdc++.so.6 -> found: /nix/store/dghjv6hfz0s0z4kffa5ahyw2mhp79215-gcc-12.3.0-lib/lib
# libimf.so -> not found!
# libgcc_s.so.1 -> found: /nix/store/l3lhzwrfgzncjj1z4wyq6kkrp6czx5qp-gcc-12.3.0-libgcc/lib
# libintlc.so.5 -> not found!
# libsycl.so.7 -> found: /nix/store/fnmcmlh980y6ix5vlxsn8fspqs2pvs8p-dpcpp-cpp-compiler-nightly-2023-12-18/lib

