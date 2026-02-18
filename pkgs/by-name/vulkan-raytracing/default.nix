{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  glslang,
  vulkan-loader,
  vulkan-headers,
  vulkan-tools,
  vulkan-validation-layers,
  freetype,
  glew,
  glfw,
  glm,
  stb,
  boost,
  SDL2,
  libGL,
  libGLU,
  xorg,
  zlib,
}: let
  tinyobjloader = stdenv.mkDerivation rec {
    pname = "tinyobjloader";
    version = "2.0-rc1";

    src = fetchFromGitHub {
      owner = "tinyobjloader";
      repo = "tinyobjloader";
      rev = "v${version}";
      sha256 = "sha256-UscZW0T3EVcG4OJX5hMdqQ0d2RvUBg5u7RsQ0y/tiJw=";
    };

    nativeBuildInputs = [cmake];

    # https://github.com/tinyobjloader/tinyobjloader/issues/336
    postPatch = ''
      substituteInPlace tinyobjloader.pc.in \
        --replace-fail '$'{prefix}/@TINYOBJLOADER_LIBRARY_DIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
        --replace-fail '$'{prefix}/@TINYOBJLOADER_INCLUDE_DIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
    '';
  };

  imgui = stdenv.mkDerivation {
    pname = "imgui";
    version = "master";

    src = fetchFromGitHub {
      owner = "opencodewin";
      repo = "imgui";
      rev = "008d29cbb4ebf14b8642979da8844d6e23696138";
      hash = "sha256-DCLMINR4V8gKqB1+CHoctVSDacz2M1/dxGvg2p2GeMQ=";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
    ];

    cmakeFlags = [
      "-DIMGUI_SKIP_INSTALL=OFF"
      "-DIMGUI_STATIC=ON"
    ];

    # preConfigure = ''
    #   substituteInPlace CMakeLists.txt \
    #     --replace-fail "ARCHIVE DESTINATION ''${CMAKE_INSTALL_LIBDIR}" "ARCHIVE DESTINATION ''${CMAKE_INSTALL_LIBDIR}\nINCLUDES DESTINATION include"
    # '';

    buildInputs = [
      vulkan-loader
      vulkan-headers
      glslang
      glfw
      glew
      freetype
      zlib
      SDL2
      libXext
      libXcursor
      libXi
      libXfixes
      libXrandr
      libXScrnSaver
    ];

    meta.broken = true;
  };
in
  stdenv.mkDerivation {
    pname = "vulkan-raytracing";
    version = "master";

    src = fetchFromGitHub {
      owner = "GPSnoopy";
      repo = "RayTracingInVulkan";
      rev = "master";
      hash = "sha256-GiKkM9k6guT/rz1UynD0JO05th5LhCzssoNSspRf63M=";
    };

    nativeBuildInputs = [
      cmake
      ninja
      pkg-config
    ];

    cmakeFlags = [
      "-DIMGUI_DIR=${imgui}/include/imgui"
      "-DSTB_INCLUDE_DIRS=${stb}/include/stb"
    ];

    preConfigure = ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "find_package(Stb REQUIRED)" "find_package(Freetype REQUIRED)" \
        --replace-fail "find_package(tinyobjloader CONFIG REQUIRED)" "find_package(tinyobjloader REQUIRED)" \

      # substituteInPlace src/CMakeLists.txt \
      #   --replace-fail "imgui::imgui" "imgui"
    '';

    buildInputs = [
      glslang
      vulkan-loader
      vulkan-headers
      vulkan-tools
      vulkan-validation-layers
      boost
      stb
      freetype
      SDL2
      imgui # does not provide cmake files
      glfw
      glm
      tinyobjloader
      libGL
      libGLU
      libX11
      libXcursor
      libXrandr
      libXinerama
    ];

    meta = with lib; {
      broken = true;
      description = "Implementation of Peter Shirley's Ray Tracing In One Weekend book using Vulkan and NVIDIA's RTX extension.";
      homepage = "https://github.com/GPSnoopy/RayTracingInVulkan";
      license = [licenses.bsd3];
      platforms = platforms.unix;
      maintainers = with maintainers; [mordrag];
    };
  }
