{fetchurl}: {
  fetchipex = {
    # base ? "https://intel-extension-for-pytorch.s3.amazonaws.com/",
    base ? "https://intel-optimized-pytorch.s3.cn-north-1.amazonaws.com.cn/",
    dist ? "ipex_stable/xpu",
    abi ? "%2Bxpu",
    python ? "cp311-cp311",
    package,
    sha256,
  }:
    fetchurl {
      inherit sha256;
      url = "${base}${dist}/${package}${abi}-${python}-linux_x86_64.whl";
    };

  fetchtorch = {
    base ? "https://download.pytorch.org/",
    dist ? "whl/nightly/xpu",
    abi ? "%2Bxpu",
    python ? "cp311-cp311",
    package,
    sha256,
  }:
    fetchurl {
      inherit sha256;
      url = "${base}${dist}/${package}${abi}-${python}-linux_x86_64.whl";
    };
}
