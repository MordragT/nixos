{
  lib,
  buildPythonPackage,
  openvino-tokenizers-native,
  openvino,
  python,
}:
buildPythonPackage {
  pname = "openvino-tokenizers";
  inherit (openvino-tokenizers-native) version;
  format = "other";

  src = openvino-tokenizers-native.python;

  dependencies = [openvino];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/${python.sitePackages}
    cp -Rv * $out/${python.sitePackages}/

    runHook postInstall
  '';

  pythonImportsCheck = [
    "openvino_tokenizers"
  ];

  meta = {
    description = "OpenVINO Tokenizers extension";
    homepage = "https://github.com/openvinotoolkit/openvino_tokenizers/tree/main";
    changelog = "https://github.com/openvinotoolkit/openvino_tokenizers/releases/tag/${openvino-tokenizers-native.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [mordrag];
  };
}
