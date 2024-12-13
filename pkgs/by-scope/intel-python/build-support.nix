{fetchurl}: {
  fetchwheel = {
    # base ? "https://intel-extension-for-pytorch.s3.amazonaws.com/",
    base ? "https://intel-optimized-pytorch.s3.cn-north-1.amazonaws.com.cn",
    dist ? "ipex_stable/xpu",
    abi ? "%2Bcxx11.abi",
    python ? "cp311-cp311",
    package,
    sha256,
  }:
    fetchurl {
      inherit sha256;
      url = "${base}${dist}/${package}${abi}-${python}-linux_x86_64.whl";
    };
}
