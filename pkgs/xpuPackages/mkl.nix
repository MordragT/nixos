{
  lib,
  stdenv,
  callPackage,
  stdenvNoCC,
  fetchurl,
  rpmextract,
  _7zz,
  darwin,
  validatePkgConfig,
  enableStatic ? stdenv.hostPlatform.isStatic,
}:
/*
For details on using mkl as a blas provider for python packages such as numpy,
numexpr, scipy, etc., see the Python section of the NixPkgs manual.
*/
let
  # Release notes and download URLs are here:
  # https://registrationcenter.intel.com/en/products/
  version = "${mklVersion}.${rel}";

  mklVersion = "2024.0";
  rel =
    if stdenvNoCC.isDarwin
    then "keineAhnung"
    else "49656";

  # Intel openmp uses its own versioning.
  openmpVersion = "2024.0.0";
  openmpRel = "49878";

  # Thread Building Blocks release.
  tbbVersion = "2021.11";
  tbbRel = "49513";

  shlibExt = stdenvNoCC.hostPlatform.extensions.sharedLibrary;

  oneapi-mkl = fetchurl {
    url = "https://yum.repos.intel.com/oneapi/intel-oneapi-mkl-${mklVersion}-${mklVersion}.0-${rel}.x86_64.rpm";
    hash = "sha256-cL/fE0RkRHx7ElPWb+FMy4XmQ+vZU1ptI6fLnvc5ojQ=";
  };

  oneapi-mkl-common = fetchurl {
    url = "https://yum.repos.intel.com/oneapi/intel-oneapi-mkl-common-${mklVersion}-${mklVersion}.0-${rel}.noarch.rpm";
    hash = "sha256-//kGPHj8eys4qd3baRgdN+GNQTXlsW6dOBRE2/t4GYg=";
  };

  oneapi-mkl-common-devel = fetchurl {
    url = "https://yum.repos.intel.com/oneapi/intel-oneapi-mkl-common-devel-${mklVersion}-${mklVersion}.0-${rel}.noarch.rpm";
    hash = "sha256-1Z48SUZ549fZ4lfm8KxI4SiQkIJeJYHuYMEE7fSP5ec=";
  };

  oneapi-mkl-devel = fetchurl {
    url = "https://yum.repos.intel.com/oneapi/intel-oneapi-mkl-devel-${mklVersion}-${mklVersion}.0-${rel}.x86_64.rpm";
    hash = "sha256-95INYH+aXMcbXyiAwzjjnq1H8NY5WHbvGP16WMVvscA=";
  };

  oneapi-openmp = fetchurl {
    url = "https://yum.repos.intel.com/oneapi/intel-oneapi-openmp-${mklVersion}-${mklVersion}.1-${openmpRel}.x86_64.rpm";
    hash = "sha256-uaEny+paTIljjljFMcR/1NT9BQuZov3LLCQ3krLXlLc=";
  };

  oneapi-tbb = fetchurl {
    url = "https://yum.repos.intel.com/oneapi/intel-oneapi-tbb-${tbbVersion}-${tbbVersion}.0-${tbbRel}.x86_64.rpm";
    hash = "sha256-lCHRDe3RFUnrBnTOxO0pkohKQmKz7LMU+47gVKj7eDQ=";
  };
in
  stdenvNoCC.mkDerivation ({
      pname = "mkl";
      inherit version;

      dontUnpack = stdenvNoCC.isLinux;

      unpackPhase =
        if stdenvNoCC.isDarwin
        then ''
          7zz x $src
        ''
        else null;

      nativeBuildInputs =
        [validatePkgConfig]
        ++ (
          if stdenvNoCC.isDarwin
          then [_7zz darwin.cctools]
          else [rpmextract]
        );

      buildPhase =
        if stdenvNoCC.isDarwin
        then ''
          for f in bootstrapper.app/Contents/Resources/packages/*/cupPayload.cup; do
            tar -xf $f
          done
          mkdir -p opt/intel
          mv _installdir opt/intel/oneapi
        ''
        else ''
          rpmextract ${oneapi-mkl}
          rpmextract ${oneapi-mkl-common}
          rpmextract ${oneapi-mkl-common-devel}
          rpmextract ${oneapi-mkl-devel}
          rpmextract ${oneapi-openmp}
          rpmextract ${oneapi-tbb}
        '';

      installPhase = ''
        mkdir -p $out
        cp -r * $out
      '';

      # installPhase =
      #   ''
      #     for f in $(find . -name 'mkl*.pc') ; do
      #       bn=$(basename $f)
      #       substituteInPlace $f \
      #         --replace $\{MKLROOT} "$out" \
      #         --replace "lib/intel64" "lib"

      #       sed -r -i "s|^prefix=.*|prefix=$out|g" $f
      #     done

      #     for f in $(find opt/intel -name 'mkl*iomp.pc') ; do
      #       substituteInPlace $f --replace "../compiler/lib" "lib"
      #     done

      #     # License
      #     # install -Dm0655 -t $out/share/doc/mkl opt/intel/oneapi/mkl/${mklVersion}/licensing/license.txt

      #     # Dynamic libraries
      #     mkdir -p $out/lib
      #     cp -a opt/intel/oneapi/mkl/${mklVersion}/lib/${lib.optionalString stdenvNoCC.isLinux "intel64"}/*${shlibExt}* $out/lib
      #     cp -a opt/intel/oneapi/compiler/${mklVersion}/${
      #       if stdenvNoCC.isDarwin
      #       then "mac"
      #       else "linux"
      #     }/compiler/lib/${lib.optionalString stdenvNoCC.isLinux "intel64_lin"}/*${shlibExt}* $out/lib
      #     cp -a opt/intel/oneapi/tbb/${tbbVersion}/lib/${lib.optionalString stdenvNoCC.isLinux "intel64/gcc4.8"}/*${shlibExt}* $out/lib

      #     # Headers
      #     cp -r opt/intel/oneapi/mkl/${mklVersion}/include $out/

      #     # CMake config
      #     cp -r opt/intel/oneapi/mkl/${mklVersion}/lib/cmake $out/lib
      #   ''
      #   + (
      #     if enableStatic
      #     then ''
      #       install -Dm0644 -t $out/lib opt/intel/oneapi/mkl/${mklVersion}/lib/${lib.optionalString stdenvNoCC.isLinux "intel64"}/*.a
      #       install -Dm0644 -t $out/lib/pkgconfig opt/intel/oneapi/mkl/${mklVersion}/lib/pkgconfig/*.pc
      #     ''
      #     else ''
      #       cp opt/intel/oneapi/mkl/${mklVersion}/lib/${lib.optionalString stdenvNoCC.isLinux "intel64"}/*${shlibExt}* $out/lib
      #       install -Dm0644 -t $out/lib/pkgconfig opt/intel/oneapi/mkl/${mklVersion}/lib/pkgconfig/*dynamic*.pc
      #     ''
      #   )
      #   + ''
      #     # Setup symlinks for blas / lapack
      #     ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/libblas${shlibExt}
      #     ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/libcblas${shlibExt}
      #     ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/liblapack${shlibExt}
      #     ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/liblapacke${shlibExt}
      #   ''
      #   + lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
      #     ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/libblas${shlibExt}".3"
      #     ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/libcblas${shlibExt}".3"
      #     ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/liblapack${shlibExt}".3"
      #     ln -s $out/lib/libmkl_rt${shlibExt} $out/lib/liblapacke${shlibExt}".3"

      #     ln -s $out/include/mkl_blas.h $out/include/blas.h
      #     ln -s $out/include/mkl_blas64.h $out/include/blas64.h
      #     ln -s $out/include/mkl_cblas.h $out/include/cblas.h
      #     ln -s $out/include/mkl_cblas64.h $out/include/cblas64.h
      #     ln -s $out/include/mkl_lapack.h $out/include/lapack.h
      #     ln -s $out/include/mkl_lapacke.h $out/include/lapacke.h
      #   '';

      # # fixDarwinDylibName fails for libmkl_cdft_core.dylib because the
      # # larger updated load commands do not fit. Use install_name_tool
      # # explicitly and ignore the error.
      # postFixup = lib.optionalString stdenvNoCC.isDarwin ''
      #   for f in $out/lib/*.dylib; do
      #     install_name_tool -id $out/lib/$(basename $f) $f || true
      #   done
      #   install_name_tool -change @rpath/libiomp5.dylib $out/lib/libiomp5.dylib $out/lib/libmkl_intel_thread.dylib
      #   install_name_tool -change @rpath/libtbb.12.dylib $out/lib/libtbb.12.dylib $out/lib/libmkl_tbb_thread.dylib
      #   install_name_tool -change @rpath/libtbbmalloc.2.dylib $out/lib/libtbbmalloc.2.dylib $out/lib/libtbbmalloc_proxy.dylib
      # '';

      # Per license agreement, do not modify the binary
      dontStrip = true;
      dontPatchELF = true;

      # passthru.tests = {
      #   pkg-config-dynamic-iomp = callPackage ./test {
      #     enableStatic = false;
      #     execution = "iomp";
      #   };
      #   pkg-config-static-iomp = callPackage ./test {
      #     enableStatic = true;
      #     execution = "iomp";
      #   };
      #   pkg-config-dynamic-seq = callPackage ./test {
      #     enableStatic = false;
      #     execution = "seq";
      #   };
      #   pkg-config-static-seq = callPackage ./test {
      #     enableStatic = true;
      #     execution = "seq";
      #   };
      # };

      meta = with lib; {
        description = "Intel OneAPI Math Kernel Library";
        longDescription = ''
          Intel OneAPI Math Kernel Library (Intel oneMKL) optimizes code with minimal
          effort for future generations of Intel processors. It is compatible with your
          choice of compilers, languages, operating systems, and linking and
          threading models.
        '';
        homepage = "https://software.intel.com/en-us/mkl";
        sourceProvenance = with sourceTypes; [binaryNativeCode];
        license = licenses.issl;
        platforms = ["x86_64-linux" "x86_64-darwin"];
        maintainers = with maintainers; [bhipple];
      };
    }
    // lib.optionalAttrs stdenvNoCC.isDarwin {
      src = fetchurl {
        url = "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/087a9190-9d96-4b8c-bd2f-79159572ed89/m_onemkl_p_${mklVersion}.${rel}_offline.dmg";
        hash = "sha256-bUaaJPSaLr60fw0DzDCjPvY/UucHlLbCSLyQxyiAi04=";
      };
    })
