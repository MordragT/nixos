{fetchurl}: {
  fetchipex = {
    pname,
    version,
    suffix ? "",
    dist ? "ipex_stable/xpu",
    python ? "cp312",
    abi ? "cp312",
    platform ? "linux_x86_64",
    hash,
  }:
    fetchurl {
      inherit hash;
      url = "https://intel-optimized-pytorch.s3.cn-north-1.amazonaws.com.cn/${dist}/${pname}-${version}${suffix}-${python}-${abi}-${platform}.whl";
    };

  fetchtorch = {
    pname,
    version,
    suffix ? "",
    dist ? "whl/nightly/xpu",
    python ? "cp312",
    abi ? "cp312",
    platform ? "linux_x86_64",
    hash,
  }:
    fetchurl {
      inherit hash;
      url = "https://download.pytorch.org/${dist}/${pname}-${version}${suffix}-${python}-${abi}-${platform}.whl";
    };
}
