{
  lib,
  stdenv,
  nodejs,
  pnpm,
  fetchFromGitHub,
  makeWrapper,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "slidev";
  version = "51.4.0";

  src = fetchFromGitHub {
    owner = "slidevjs";
    repo = "slidev";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9Cl/E9zTzrb6bxvohXHg2tn2hWL6KLNAwFJFXLyU42I=";
  };

  dontCheckForBrokenSymlinks = true;

  nativeBuildInputs = [nodejs pnpm.configHook makeWrapper];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-yzs3ng8juMt5eCb9PA5YIJ6vaaKCIbWWpWy6RZhKC48=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm --filter @slidev/cli build
    pnpm --filter @slidev/parser build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r packages $out/packages
    cp -r node_modules $out/node_modules

    makeWrapper "${nodejs}/bin/node" "$out/bin/slidev" \
      --set NODE_PATH "$out/node_modules" \
      --add-flags "$out/packages/slidev/bin/slidev.mjs"

    runHook postInstall
  '';

  meta = {
    description = "Presentation Slides for Developers";
    homepage = "https://sli.dev/";
    changelog = "https://github.com/slidevjs/slidev/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "slidev";
    maintainers = with lib.maintainers; [mordrag];
  };
})
