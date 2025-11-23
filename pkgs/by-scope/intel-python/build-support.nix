{fetchurl}: {
  fetchipex = {
    pname,
    version,
    suffix ? "",
    dist ? "ipex_stable/xpu",
    python ? "cp314",
    abi ? "cp314",
    platform ? "linux_x86_64",
    hash,
  }:
    fetchurl {
      inherit hash;
      url = "https://download.pytorch-extension.intel.com/${dist}/${pname}-${version}${suffix}-${python}-${abi}-${platform}.whl";
    };

  fetchtorch = {
    pname,
    version,
    suffix ? "",
    dist ? "whl/xpu",
    python ? "cp314",
    abi ? "cp314",
    platform ? "linux_x86_64",
    # platform ? "manylinux_2_28_x86_64",
    hash,
  }:
    fetchurl {
      inherit hash;
      url = "https://download.pytorch.org/${dist}/${pname}-${version}${suffix}-${python}-${abi}-${platform}.whl";
    };
}
