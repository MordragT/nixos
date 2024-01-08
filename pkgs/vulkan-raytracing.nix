{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  boost,
  glslang,
  vulkan-loader,
  vulkan-headers,
  vulkan-tools,
  vulkan-validation-layers,
  glfw,
  glm,
  tinyobjloader,
  imgui,
  libGL,
  libGLU,
  xorg,
}:
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
  ];

  preConfigure = ''
    export CMAKE_PREFIX_PATH="${imgui}:$CMAKE_PREFIX_PATH"
  '';

  buildInputs = [
    boost
    glslang
    vulkan-loader
    vulkan-headers
    vulkan-tools
    vulkan-validation-layers
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
