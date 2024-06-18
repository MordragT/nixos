{fetchurl}: {
  fetchwheel = {
    dist ? "ipex_stable/xpu",
    abi ? "%2Bcxx11.abi",
    python ? "cp311-cp311",
    package,
    sha256,
  }:
    fetchurl {
      inherit sha256;
      url = "https://intel-extension-for-pytorch.s3.amazonaws.com/${dist}/${package}${abi}-${python}-linux_x86_64.whl";
    };
}
