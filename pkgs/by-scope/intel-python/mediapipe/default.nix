{
  lib,
  fetchurl,
  buildPythonPackage,
  fetchPypi,
  python,
  protobuf,
  numpy,
  opencv4,
  attrs,
  matplotlib,
  autoPatchelfHook,
}: let
  pose = fetchurl {
    url = "https://storage.googleapis.com/mediapipe-assets/pose_landmark_heavy.tflite";
    sha256 = "sha256-WeQtcbzUTL26vEGfD/dmhllf0mVBlWa9QAnvcD6o4f4=";
  };
in
  buildPythonPackage rec {
    pname = "mediapipe";
    version = "0.10.20";
    format = "wheel";

    src = fetchPypi {
      inherit pname version format;
      dist = "cp312";
      python = "cp312";
      abi = "cp312";
      platform = "manylinux_2_28_x86_64";
      hash = "sha256-8EUrfIY+wM0cY2DwuB/iSSxWCI3oCt+PNkLFe0Xh8dM=";
    };

    nativeBuildInputs = [autoPatchelfHook];

    dependencies = [
      protobuf
      numpy
      opencv4
      matplotlib
      attrs
    ];

    postInstall = ''
      cp ${pose} $out/${python.sitePackages}/mediapipe/modules/pose_landmark/pose_landmark_heavy.tflite
    '';

    pythonImportsCheck = ["mediapipe"];

    meta = with lib; {
      description = "Cross-platform, customizable ML solutions for live and streaming media";
      homepage = "https://github.com/google/mediapipe/releases/tag/v0.10.8";
      license = licenses.asl20;
      maintainers = with maintainers; [mordrag];
    };
  }
