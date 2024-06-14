{
  lib,
  python3-xpu,
  linkFarm,
  makeWrapper,
  writeTextFile,
  fetchFromGitHub,
  stdenv,
  dataPath ? "/var/lib/comfyui",
  modelsPath ? "${dataPath}/models",
  inputPath ? "${dataPath}/input",
  outputPath ? "${dataPath}/output",
  tempPath ? "${dataPath}/temp",
  userPath ? "${dataPath}/user",
  customNodes ? [],
}: let
  modelPathsFile = writeTextFile {
    name = "model_paths.yaml";
    text = lib.generators.toYAML {} {
      comfyui = {
        base_path = modelsPath;
        checkpoints = "${modelsPath}/checkpoints";
        clip = "${modelsPath}/clip";
        clip_vision = "${modelsPath}/clip_vision";
        configs = "${modelsPath}/configs";
        controlnet = "${modelsPath}/controlnet";
        embeddings = "${modelsPath}/embeddings";
        loras = "${modelsPath}/loras";
        upscale_models = "${modelsPath}/upscale_models";
        vae = "${modelsPath}/vae";
        vae_approx = "${modelsPath}/vae_approx";
      };
    };
  };
  pythonEnv =
    python3-xpu
    .withPackages (ps:
      with ps;
        [
          ipex
          torch
          torchvision
          torchsde
          torchaudio
          transformers
          safetensors
          accelerate
          aiohttp
          einops
          pyyaml
          pillow
          scipy
          psutil
          tqdm
          kornia
          spandrel
          # oneccl-bind-pt
        ]
        ++ (builtins.concatMap (node: node.dependencies) customNodes));
  customNodesCollection = (
    linkFarm "comfyui-custom-nodes" (builtins.map (pkg: {
        name = pkg.pname;
        path = pkg;
      })
      customNodes)
  );
in
  stdenv.mkDerivation {
    pname = "comfyui";
    version = "unstable-2024-06-12";

    src = fetchFromGitHub {
      owner = "comfyanonymous";
      repo = "ComfyUI";
      rev = "c8b5e08dc39171babb5d43f160cc04271591743e";
      hash = "sha256-CxRiJRtqDvmvdVk0bpMLngs18gUZR7Wv9np5xZDYgXw=";
    };

    # doCheck = false;

    nativeBuildInputs = [
      makeWrapper
      # setuptools
      # pythonRelaxDepsHook
    ];

    # pythonRemoveDeps = [
    #   "spandrel"
    # ];

    # dependencies = [
    #   ipex
    #   torch
    #   torchvision
    #   torchsde
    #   torchaudio
    #   transformers
    #   safetensors
    #   accelerate
    #   aiohttp
    #   einops
    #   pyyaml
    #   pillow
    #   scipy
    #   psutil
    #   tqdm
    #   kornia
    # ];

    # preBuild = ''
    #   cat > setup.py << EOF
    #   from setuptools import setup

    #   with open('requirements.txt') as f:
    #       install_requires = f.read().splitlines()

    #   setup(
    #     name='comfyui',
    #     version='2024.06.12',
    #     author='comfyanonymous',
    #     description='The most powerful and modular stable diffusion GUI, api and backend with a graph/nodes interface.',
    #     packages=['app', 'comfy', 'comfy_extras', 'comfyui'],
    #     package_dir={'comfyui': '.'},
    #     package_data={
    #       'comfy': ['**/*.json', '*.js', '*.ts', '*.css', '*.html'],
    #       'comfyui': ['web/*'],
    #     },
    #     include_package_data=True,
    #     install_requires=install_requires,
    #     # scripts=[
    #     #   'someprogram.py',
    #     # ],
    #     entry_points={
    #       # example: file some_module.py -> function main
    #       'console_scripts': ['comfyui=comfyui:main']
    #     },
    #   )
    #   EOF
    # '';

    installPhase = ''
      mkdir -p $out/bin/

      cp -r $src/app $out/app
      cp -r $src/comfy $out/comfy
      cp -r $src/comfy_extras $out/comfy_extras
      cp -r $src/web $out/web
      cp -r $src/*.py $out/

      cp ${modelPathsFile} $out/extra_model_paths.yaml

      ln -s ${inputPath} $out/input
      ln -s ${outputPath} $out/output
      ln -s ${customNodesCollection} $out/custom_nodes

      # makeWrapper ${pythonEnv}/bin/ipexrun $out/bin/comfyui \
      #   --add-flags "xpu $out/main.py --input-directory ${inputPath} --output-directory ${outputPath} --extra-model-paths-config ${modelPathsFile} --temp-directory ${tempPath}"
      makeWrapper ${pythonEnv}/bin/python $out/bin/comfyui \
        --add-flags "$out/main.py --input-directory ${inputPath} --output-directory ${outputPath} --extra-model-paths-config ${modelPathsFile} --temp-directory ${tempPath}"

      substituteInPlace $out/folder_paths.py --replace 'os.path.join(os.path.dirname(os.path.realpath(__file__)), "user")' '"${userPath}"'
    '';

    meta = with lib; {
      homepage = "https://github.com/comfyanonymous/ComfyUI";
      description = "The most powerful and modular stable diffusion GUI with a graph/nodes interface.";
      license = licenses.gpl3;
      platforms = platforms.all;
      maintainers = with maintainers; [mordrag];
    };
  }
