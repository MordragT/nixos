{pkgs}: {
  default = pkgs.mkShell {
    # MKLROOT = pkgs.intelPackages.mkl;
    # TBBROOT = pkgs.intelPackages.tbb;
    # # dpcpp
    # DPCPPROOT = pkgs.intelPackages.runtime;
    # CMPLR_ROOT = pkgs.intelPackages.runtime;
    # OCL_ICD_FILENAMES = "${pkgs.intelPackages.runtime}/lib/libintelocl.so:/run/opengl-driver/lib/intel-opencl/libigdrcl.so";

    # DNNLROOT = pkgs.oneapiPackages.dnn;

    # LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
    # LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
    # DYLD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;

    # INTEL_TARGET_ARCH = "intel64";

    buildInputs = with pkgs; [
      # env
      (python3.withPackages
        (ps:
          with ps; [
            ipex
            torchWithXpu
            # torchvisionWithXpu
          ]))
      # intelPackages.runtime
      # intelPackages.dpcpp
      # intelPackages.mkl
      # intelPackages.tbb
      # oneapiPackages.dnn
    ];

    shellHook = with pkgs.intelPackages; ''
      # https://github.com/intel/compute-runtime/issues/710#issuecomment-2002646557
      # export NEOReadDebugKeys=1
      # export OverrideGpuAddressSpace=48
      # https://github.com/intel/intel-extension-for-pytorch/issues/538#issuecomment-1993611525
      # export LD_PRELOAD=${pkgs.stdenv.cc.cc.lib}/lib/libstdc++.so

      export OCL_ICD_FILENAMES=/run/opengl-driver/lib/intel-opencl/libigdrcl.so

      source ${runtime}/env/vars.sh
      source ${mkl}/env/vars.sh

      python -c "import torch; import intel_extension_for_pytorch as ipex; print(torch.__version__); print(ipex.__version__); [print(f'[{i}]: {torch.xpu.get_device_properties(i)}') for i in range(torch.xpu.device_count())];"
    '';
  };
  stable-diffusion-webui = import ./stable-diffusion-webui.nix {inherit pkgs;};
}
