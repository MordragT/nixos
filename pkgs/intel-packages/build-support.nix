{fetchurl}: {
  # https://apt.repos.intel.com/oneapi/dists/all/main/binary-amd64/Packages
  # https://apt.repos.intel.com/oneapi/dists/all/main/binary-all/Packages
  fetchdeb = {
    package,
    hash,
  }:
    fetchurl {
      inherit hash;
      url = "https://apt.repos.intel.com/oneapi/pool/main/${package}.deb";
    };
}
