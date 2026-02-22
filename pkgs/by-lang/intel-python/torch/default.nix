{
  intel-sycl,
  lib,
  fetchFromGitHub,
  fetchFromGitLab,
  git-unroll,
  buildPythonPackage,
  python,
  runCommand,
  writeShellScript,
  callPackage,
  applyPatches,
  # Native build inputs
  cmake,
  which,
  pybind11,
  pkg-config,
  breakpointHook,
  # Build inputs
  openssl,
  oneapi-dnn,
  pti-gpu,
  intel-compute-runtime,
  ocl-icd,
  opencl-headers,
  level-zero,
  # dependencies
  astunparse,
  binutils,
  expecttest,
  filelock,
  fsspec,
  hypothesis,
  jinja2,
  networkx,
  packaging,
  psutil,
  pyyaml,
  requests,
  sympy,
  types-dataclasses,
  typing-extensions,
  triton-xpu,
  # ninja (https://ninja-build.org) must be available to run C++ extensions tests,
  ninja,
  # dependencies for torch.utils.tensorboard
  pillow,
  six,
  tensorboard,
  protobuf,
}:
let
  setBool = v: if v then "1" else "0";
  sycl_compiler_version = "20260101"; # todo expose via passthruu for intel-sycl.llvm or soemthing
  torch-xpu-ops-source = applyPatches {
    src = fetchFromGitHub {
      owner = "intel";
      repo = "torch-xpu-ops";
      rev = "789f59d8261b521282a26025c4a7a201621b4683";
      hash = "sha256-CzSqypAX15FmGXriGzK6t/oOkbaRS6DxPXCHRmptbV4=";
    };
    patches = [
      ./xpu-ops-llvm.patch
    ];
  };
in
buildPythonPackage.override { stdenv = intel-sycl.compatStdenv; } rec {
  pname = "torch";
  version = "2.9.1";
  pyproject = true;

  outputs = [
    "out" # output standard python package
    "dev" # output libtorch headers
    "lib" # output libtorch libraries
  ];

  src = callPackage ./src.nix {
    inherit
      version
      fetchFromGitHub
      fetchFromGitLab
      runCommand
      ;
  };

  patches = [
    ./clang19-template-warning.patch
    ./find-sycl.patch
    ./xpu-mkldnn-source.patch
    ./xpu-ops-source.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=70.1.0,<80.0" "setuptools"
  ''
  # What is more idiomatic ? Using subst-var-by or $ENV{...} in cmake ?
  + ''
    substituteInPlace caffe2/CMakeLists.txt \
      --subst-var-by torch_xpu_ops_path ${torch-xpu-ops-source}
  ''
  + ''
    substituteInPlace cmake/Modules/FindSYCLToolkit.cmake \
      --subst-var-by sycl_compiler_version ${sycl_compiler_version} \
      --subst-var-by clang_root "${intel-sycl.stdenv.cc}"
  ''
  + ''
    substituteInPlace cmake/Modules/FindMKLDNN.cmake \
      --subst-var-by xpu_mkldnn_source ${oneapi-dnn.src} \
      --subst-var-by clang_exe "${intel-sycl.stdenv.cc}/bin/clang" \
      --subst-var-by clang++_exe "${intel-sycl.stdenv.cc}/bin/clang++"
  ''
  # Provide path to openssl binary for inductor code cache hash
  # InductorError: FileNotFoundError: [Errno 2] No such file or directory: 'openssl'
  + ''
    substituteInPlace torch/_inductor/codecache.py \
      --replace-fail '"openssl"' '"${lib.getExe openssl}"'
  ''
  # annotations (3.7), print_function (3.0), with_statement (2.6) are all supported
  + ''
    sed -i -e "/from __future__ import/d" **.py
    substituteInPlace third_party/NNPACK/CMakeLists.txt \
      --replace-fail "PYTHONPATH=" 'PYTHONPATH=$ENV{PYTHONPATH}:'
  ''
  # Ensure that torch profiler unwind uses addr2line from nix
  + ''
    substituteInPlace torch/csrc/profiler/unwind/unwind.cpp \
      --replace-fail 'addr2line_binary_ = "addr2line"' 'addr2line_binary_ = "${lib.getExe' binutils "addr2line"}"'
  ''
  # Ensures torch compile can find and use compilers from nix.
  + ''
    substituteInPlace torch/_inductor/config.py \
      --replace-fail '"clang++" if sys.platform == "darwin" else "g++"' \
      '"${lib.getExe' intel-sycl.stdenv.cc "${intel-sycl.stdenv.cc.targetPrefix}c++"}"'
  '';

  preConfigure = ''
    # Erstelle einen dedizierten Ordner für den Codegen
    mkdir -p build/codegen_xpu

    # 1. Kopiere die Basis-Templates von PyTorch
    cp -r aten/src/ATen/templates build/codegen_xpu/

    # 2. Kopiere die XPU-spezifischen YAMLs darüber
    cp -r ${torch-xpu-ops-source}/yaml/* build/codegen_xpu/
  '';

  # Use pytorch's custom configurations
  dontUseCmakeConfigure = true;

  BUILD_NAMEDTENSOR = setBool true;
  BUILD_DOCS = setBool false;
  BUILD_TEST = setBool false;

  # Unlike MKL, oneDNN (née MKLDNN) is FOSS, so we enable support for
  # it by default. PyTorch currently uses its own vendored version
  # of oneDNN through Intel iDeep.
  USE_MKLDNN = setBool true;
  USE_MKLDNN_CBLAS = setBool true;

  USE_XPU = setBool true;
  USE_ONEMKL_XPU = setBool false; # muss aktiviert sein?
  USE_CUDA = setBool false;
  USE_NCCL = setBool false;
  USE_NINJA = setBool true;

  # Avoid using pybind11 from git submodule
  # Also avoids pytorch exporting the headers of pybind11
  USE_SYSTEM_PYBIND11 = true;

  # cmakeFlags = [
  #   (lib.cmakeFeature "PYTHON_SIX_SOURCE_DIR" "${six.src}")
  #   # (lib.cmakeFeature "XPU_MKLDNN_SOURCE_DIR" "${oneapi-dnn.src}")
  #   # (lib.cmakeFeature "SYCL_COMPILER_VERSION" "20260101")
  # ];

  preBuild = ''
    export MAX_JOBS=$NIX_BUILD_CORES
    ${python.pythonOnBuildForHost.interpreter} setup.py build --cmake-only
    ${cmake}/bin/cmake build
  '';

  # Override the (weirdly) wrong version set by default. See
  # https://github.com/NixOS/nixpkgs/pull/52437#issuecomment-449718038
  # https://github.com/pytorch/pytorch/blob/v1.0.0/setup.py#L267
  PYTORCH_BUILD_VERSION = version;
  PYTORCH_BUILD_NUMBER = 0;

  # Set the correct Python library path, broken since
  # https://github.com/pytorch/pytorch/commit/3d617333e
  PYTHON_LIB_REL_PATH = "${placeholder "out"}/${python.sitePackages}";

  # disable warnings as errors as they break the build on every compiler
  # bump, among other things.
  # Also of interest: pytorch ignores CXXFLAGS uses CFLAGS for both C and C++:
  # https://github.com/pytorch/pytorch/blob/v1.11.0/setup.py#L17
  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  nativeBuildInputs = [
    cmake
    which
    ninja
    pybind11
    pkg-config
    breakpointHook
  ];

  buildInputs = [
    intel-sycl.openmp
    pti-gpu.sdk
    ocl-icd
    opencl-headers
    level-zero
  ];

  pythonRelaxDeps = [
    "sympy"
  ];

  pythonRemoveDeps = [
    # In our dist-info the name is just "triton"
    "pytorch-triton-rocm"
  ];

  dependencies = [
    astunparse
    expecttest
    filelock
    fsspec
    hypothesis
    jinja2
    networkx
    packaging
    psutil
    pyyaml
    requests
    sympy
    types-dataclasses
    typing-extensions

    # the following are required for tensorboard support
    pillow
    six
    tensorboard
    protobuf

    # torch/csrc requires `pybind11` at runtime
    pybind11
    triton-xpu
  ];

  # Tests take a long time and may be flaky, so just sanity-check imports
  doCheck = false;

  pythonImportsCheck = [ "torch" ];

  postInstall = ''
    mkdir $dev

    # CppExtension requires that include files are packaged with the main
    # python library output; which is why they are copied here.
    cp -r $out/${python.sitePackages}/torch/include $dev/include

    # Cmake files under /share are different and can be safely moved. This
    # avoids unnecessary closure blow-up due to apple sdk references when
    # USE_DISTRIBUTED is enabled.
    mv $out/${python.sitePackages}/torch/share $dev/share

    # Fix up library paths for split outputs
    substituteInPlace \
      $dev/share/cmake/Torch/TorchConfig.cmake \
      --replace-fail \''${TORCH_INSTALL_PREFIX}/lib "$lib/lib"

    substituteInPlace \
      $dev/share/cmake/Caffe2/Caffe2Targets-release.cmake \
      --replace-fail \''${_IMPORT_PREFIX}/lib "$lib/lib"

    mkdir $lib
    mv $out/${python.sitePackages}/torch/lib $lib/lib
    ln -s $lib/lib $out/${python.sitePackages}/torch/lib
  '';

  # Builds in 2+h with 2 cores, and ~15m with a big-parallel builder.
  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    changelog = "https://github.com/pytorch/pytorch/releases/tag/v${version}";
    # keep PyTorch in the description so the package can be found under that name on search.nixos.org
    description = "PyTorch: Tensors and Dynamic neural networks in Python with strong GPU acceleration";
    homepage = "https://pytorch.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      mordrag
    ];
    platforms = lib.platforms.linux;
  };
}
