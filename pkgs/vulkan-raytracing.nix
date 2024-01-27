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
  glfw,
  glm,
  stb,
  boost,
  SDL2,
  imgui,
  libGL,
  libGLU,
  xorg,
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
        --replace '$'{prefix}/@TINYOBJLOADER_LIBRARY_DIR@ @CMAKE_INSTALL_FULL_LIBDIR@ \
        --replace '$'{prefix}/@TINYOBJLOADER_INCLUDE_DIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
    '';
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
        --replace "find_package(imgui CONFIG REQUIRED)" '
            add_library(imgui STATIC)

            # set(IMGUI_DIR $ENV{IMGUI_DIR})
            target_sources( imgui
                            PRIVATE
                                ''${IMGUI_DIR}/imgui_demo.cpp
                                ''${IMGUI_DIR}/imgui_draw.cpp
                                ''${IMGUI_DIR}/imgui_tables.cpp
                                ''${IMGUI_DIR}/imgui_widgets.cpp
                                ''${IMGUI_DIR}/imgui.cpp

                            PRIVATE
                                ''${IMGUI_DIR}/backends/imgui_impl_opengl3.cpp
                                ''${IMGUI_DIR}/backends/imgui_impl_sdl2.cpp

                            PRIVATE
                                ''${IMGUI_DIR}/misc/freetype/imgui_freetype.cpp
                            )

            find_path(SDL2_DIR "SDL2/SDL.h")
            target_include_directories( imgui
                                        PUBLIC ''${IMGUI_DIR}
                                        PUBLIC ''${IMGUI_DIR}/backends
                                        PUBLIC ''${IMGUI_DIR}/misc/freetype
                                        PUBLIC ''${SDL2_DIR}/SDL2
                                        )
        ' \
        --replace "find_package(Stb REQUIRED)" "find_package(Freetype REQUIRED)" \
        --replace "find_package(tinyobjloader CONFIG REQUIRED)" "find_package(tinyobjloader REQUIRED)" \

      substituteInPlace src/CMakeLists.txt \
        --replace "imgui::imgui" "imgui"
    '';

    # IMGUI_DIR = "${imgui}/include/imgui";
    # STB_DIR = "${stb}/include/stb";

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
      xorg.libX11
      xorg.libXcursor
      xorg.libXrandr
      xorg.libXinerama
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
