{
  stdenv,
  stdenvNoCC,
  fetchinteldeb,
  autoPatchelfHook,
  dpkg,
  intel-dpcpp,
  intel-mpi,
  ocl-icd,
}: let
  major = "2024.2";
  version = "2024.2.0-663";

  mkl = fetchinteldeb {
    package = "intel-oneapi-mkl-${major}-${version}_amd64";
    hash = "sha256-fh8GOzIqVBNL6wbWQ6nzli99QA8cPoVsdAnJk42EqOw=";
  };
  mkl-devel = fetchinteldeb {
    package = "intel-oneapi-mkl-devel-${major}-${version}_amd64";
    hash = "sha256-lYas7a1b1AKJSmg/xN5SmeImV2enid34mbPiHNcTx88=";
  };
  mkl-runtime = fetchinteldeb {
    package = "intel-oneapi-runtime-mkl-2024-${version}_amd64";
    hash = "sha256-IikuxDNKSQZxGcNwytazNKKmuV6SOCjjyPuN+mPAkNU=";
  };
  mkl-core = fetchinteldeb {
    package = "intel-oneapi-mkl-core-${major}-${version}_amd64";
    hash = "sha256-lw9iDIGUHnOAALsdJHE4USABlRz3D9P3mJwpvG8mfRY=";
  };
  mkl-core-common = fetchinteldeb {
    package = "intel-oneapi-mkl-core-common-${major}-${version}_all";
    hash = "sha256-/DrcCXPau9dt1zTpMY9wSyCVvKd11HyWjXKJ61eACCs=";
  };
  mkl-core-devel = fetchinteldeb {
    package = "intel-oneapi-mkl-core-devel-${major}-${version}_amd64";
    hash = "sha256-8qt/eHkrB4iWyPRuJuqv3dBAxalS3V13hcdmyfeQrJQ=";
  };
  mkl-core-devel-common = fetchinteldeb {
    package = "intel-oneapi-mkl-core-devel-common-${major}-${version}_all";
    hash = "sha256-vkRdx5mDDArE7hW1nNjXuywVpPzrmWkzlNaHCQ1NjFc=";
  };
  mkl-cluster = fetchinteldeb {
    package = "intel-oneapi-mkl-cluster-${major}-${version}_amd64";
    hash = "sha256-BofTpnth9mNtkBFpJPKCeNOzfooTIQnFQyx3OJRZm5w=";
  };
  mkl-cluster-devel = fetchinteldeb {
    package = "intel-oneapi-mkl-cluster-devel-${major}-${version}_amd64";
    hash = "sha256-2Flx1HMuL3hARV9hSjgg4VTTBdTzs8daAzABxhcsySI=";
  };
  mkl-cluster-devel-common = fetchinteldeb {
    package = "intel-oneapi-mkl-cluster-devel-common-${major}-${version}_all";
    hash = "sha256-ZKUiBIItZ998GyAeVrOoqQ7prFiDcxrSCm+sx/uo1/o=";
  };
  mkl-sycl = fetchinteldeb {
    package = "intel-oneapi-mkl-sycl-${major}-${version}_amd64";
    hash = "sha256-rVF4cfQtAfOJlM9Rkqt/JS9QrOnTDMYE/wd2q3GAJng=";
  };
  mkl-sycl-devel = fetchinteldeb {
    package = "intel-oneapi-mkl-sycl-devel-${major}-${version}_amd64";
    hash = "sha256-N/hxXVJnouivD95/XWe3HWe0y1tgBs0Z+W3MidQGHx4=";
  };
  mkl-sycl-devel-common = fetchinteldeb {
    package = "intel-oneapi-mkl-sycl-devel-common-${major}-${version}_all";
    hash = "sha256-VTyvqE4Vvn6BP3lWjo1Y19oTmnnf+pG9BG4L12zfPlY=";
  };
  mkl-sycl-include = fetchinteldeb {
    package = "intel-oneapi-mkl-sycl-include-${major}-${version}_amd64";
    hash = "sha256-wVaBpmQ7LvOiNBncsTU+i3YXB7ZkwxttZpF7Gi0lR8Q=";
  };
  mkl-sycl-blas = fetchinteldeb {
    package = "intel-oneapi-mkl-sycl-blas-${major}-${version}_amd64";
    hash = "sha256-QCSAMdmrj002B/SKNRkjNpGOdkZ2a4N22GSKRZz3Ols=";
  };
  mkl-sycl-lapack = fetchinteldeb {
    package = "intel-oneapi-mkl-sycl-lapack-${major}-${version}_amd64";
    hash = "sha256-wgrFh2hS8eo5NGJyMiJSSZ0mZaA9KgFWaOK3FjxurVU=";
  };
  mkl-sycl-dft = fetchinteldeb {
    package = "intel-oneapi-mkl-sycl-dft-${major}-${version}_amd64";
    hash = "sha256-bThxenOdafm73rKXzhHvtwsMHxLSmBxOGIpRA84RKGk=";
  };
  mkl-sycl-sparse = fetchinteldeb {
    package = "intel-oneapi-mkl-sycl-sparse-${major}-${version}_amd64";
    hash = "sha256-RkaH/yT4101ez/Khwc9tTAny1wjDHq5Yzl8XS6E8Ofw=";
  };
  mkl-sycl-vm = fetchinteldeb {
    package = "intel-oneapi-mkl-sycl-vm-${major}-${version}_amd64";
    hash = "sha256-zuyvvwVPNRsxbb+fjg1+zVfk2LEk4Xobdrk6DWBEsvU=";
  };
  mkl-sycl-rng = fetchinteldeb {
    package = "intel-oneapi-mkl-sycl-rng-${major}-${version}_amd64";
    hash = "sha256-HDzi6lVlyarKOWuayYebGSzON1fbIdtCLXW+4t+Mmwo=";
  };
  mkl-sycl-stats = fetchinteldeb {
    package = "intel-oneapi-mkl-sycl-stats-${major}-${version}_amd64";
    hash = "sha256-m+BFjMsC94az/B7kCuJN5Ugk5wQylaO3k73oDBiakEQ=";
  };
  mkl-sycl-data-fitting = fetchinteldeb {
    package = "intel-oneapi-mkl-sycl-data-fitting-${major}-${version}_amd64";
    hash = "sha256-616XwlkoeURKYyvrGBjrmRGm1prNL4jmAZvjMB9xlKY=";
  };
  mkl-classic = fetchinteldeb {
    package = "intel-oneapi-mkl-classic-${major}-${version}_amd64";
    hash = "sha256-dj7tbnx+X4gtXN+NguNiHRkti5NRn6GNegsogF23Uas=";
  };
  mkl-classic-devel = fetchinteldeb {
    package = "intel-oneapi-mkl-classic-devel-${major}-${version}_amd64";
    hash = "sha256-+KDWZzjMeZefKI/3XpSC1oMgBx14n0RvQFcfENEF63g=";
  };
  mkl-classic-include = fetchinteldeb {
    package = "intel-oneapi-mkl-classic-include-${major}-${version}_amd64";
    hash = "sha256-yUzfYGljsNIynOnuur8kjMHkqupVhJpUd+/Z7aCmiUc=";
  };
  mkl-classic-include-common = fetchinteldeb {
    package = "intel-oneapi-mkl-classic-include-common-${major}-${version}_all";
    hash = "sha256-cJGtUut3LD4ehcEPANJdbNBSBtxLLyHgVgqIHPfzGM8=";
  };
in
  stdenvNoCC.mkDerivation {
    inherit version;
    pname = "intel-mkl";

    dontStrip = true;
    # dontUnpack = true;

    nativeBuildInputs = [autoPatchelfHook dpkg];

    buildInputs = [
      intel-dpcpp.llvm.lib
      intel-mpi
      stdenv.cc.cc.lib
      ocl-icd
    ];

    unpackPhase = ''
      dpkg-deb -x ${mkl} .
      dpkg-deb -x ${mkl-devel} .
      dpkg-deb -x ${mkl-runtime} .
      dpkg-deb -x ${mkl-core} .
      dpkg-deb -x ${mkl-core-common} .
      dpkg-deb -x ${mkl-core-devel} .
      dpkg-deb -x ${mkl-core-devel-common} .
      dpkg-deb -x ${mkl-cluster} .
      dpkg-deb -x ${mkl-cluster-devel} .
      dpkg-deb -x ${mkl-cluster-devel-common} .
      dpkg-deb -x ${mkl-sycl} .
      dpkg-deb -x ${mkl-sycl-devel} .
      dpkg-deb -x ${mkl-sycl-devel-common} .
      dpkg-deb -x ${mkl-sycl-include} .
      dpkg-deb -x ${mkl-sycl-blas} .
      dpkg-deb -x ${mkl-sycl-lapack} .
      dpkg-deb -x ${mkl-sycl-dft} .
      dpkg-deb -x ${mkl-sycl-sparse} .
      dpkg-deb -x ${mkl-sycl-vm} .
      dpkg-deb -x ${mkl-sycl-rng} .
      dpkg-deb -x ${mkl-sycl-stats} .
      dpkg-deb -x ${mkl-sycl-data-fitting} .
      dpkg-deb -x ${mkl-classic} .
      dpkg-deb -x ${mkl-classic-devel} .
      dpkg-deb -x ${mkl-classic-include} .
      dpkg-deb -x ${mkl-classic-include-common} .
    '';

    installPhase = ''
      mkdir -p $out
      mkdir -p $out/share

      cd ./opt/intel/oneapi/mkl/${major}

      mv bin $out/bin
      mv env $out/env
      mv etc/mkl $out/env/mkl
      mv include $out/include
      mv lib $out/lib
      # mv lib32 $out/lib32

      ln -s $out/lib/libmkl_rt.so $out/lib/libblas.so
      ln -s $out/lib/libmkl_rt.so $out/lib/libcblas.so
      ln -s $out/lib/libmkl_rt.so $out/lib/liblapack.so
      ln -s $out/lib/libmkl_rt.so $out/lib/liblapacke.so
      ln -s $out/lib/libmkl_rt.so $out/lib/libblas.so.3
      ln -s $out/lib/libmkl_rt.so $out/lib/libcblas.so.3
      ln -s $out/lib/libmkl_rt.so $out/lib/liblapack.so.3
      ln -s $out/lib/libmkl_rt.so $out/lib/liblapacke.so.3

      ln -s $out/lib/libmkl_intel_ilp64.so.2 $out/lib/libblas64.so.3
      ln -s $out/lib/libmkl_intel_ilp64.so.2 $out/lib/libcblas64.so.3
      ln -s $out/lib/libmkl_intel_ilp64.so.2 $out/lib/liblapack64.so.3
      ln -s $out/lib/libmkl_intel_ilp64.so.2 $out/lib/liblapacke64.so.3
      ln -s $out/lib/liblapack.so.3 $out/lib/libblas64.so
      ln -s $out/lib/libcblas64.so.3 $out/lib/libcblas64.so
      ln -s $out/lib/liblapack64.so.3 $out/lib/liblapack64.so
      ln -s $out/lib/liblapacke64.so.3 $out/lib/liblapacke64.so
      rm $out/lib/intel64

      cd share

      mv doc $out/share/doc
      mv locale $out/share/locale
    '';
  }
