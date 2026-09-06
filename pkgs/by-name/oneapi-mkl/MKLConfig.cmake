include(FeatureSummary)
include(CMakeFindDependencyMacro)

set_package_properties(MKL PROPERTIES DESCRIPTION "Intel oneAPI MKL Compatibility Shim for Nix")

# 1. Host C API (MKL::MKL) mapping to classic Nix mkl
if(NOT TARGET MKL::MKL)
  add_library(MKL::MKL INTERFACE IMPORTED)

  find_path(MKL_INCLUDE_DIR mkl.h)
  find_library(MKL_CORE_LIB mkl_core)
  find_library(MKL_INTERFACE_LIB NAMES mkl_intel_ilp64 mkl_intel_lp64)
  find_library(MKL_THREAD_LIB NAMES mkl_gnu_thread mkl_intel_thread mkl_sequential)

  set_target_properties(MKL::MKL PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${MKL_INCLUDE_DIR}"
    INTERFACE_LINK_LIBRARIES "${MKL_INTERFACE_LIB};${MKL_THREAD_LIB};${MKL_CORE_LIB}"
  )
endif()

# 2. SYCL API (MKL::MKL_SYCL) mapping to oneMath
if(NOT TARGET MKL::MKL_SYCL)
  # Find package by its actual lowercase package name
  find_dependency(onemath_sycl_blas)
  find_dependency(oneMath)

  add_library(MKL::MKL_SYCL INTERFACE IMPORTED)

  set_target_properties(MKL::MKL_SYCL PROPERTIES
    INTERFACE_LINK_LIBRARIES "ONEMATH::onemath"
    INTERFACE_COMPILE_OPTIONS "-fsycl"
    INTERFACE_LINK_OPTIONS "-fsycl"
  )

  if(NOT TARGET MKL::MKL_SYCL::BLAS)
    add_library(MKL::MKL_SYCL::BLAS INTERFACE IMPORTED)
    set_target_properties(MKL::MKL_SYCL::BLAS PROPERTIES
      INTERFACE_LINK_LIBRARIES "MKL::MKL_SYCL"
    )
  endif()
endif()

set(MKL_FOUND TRUE)
set(MKL_SYCL_FOUND TRUE)
