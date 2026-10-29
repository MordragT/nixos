{
  buildNpmPackage,
  fetchurl,
  autoPatchelfHook,
  libgcc,
}:

# Upstream publishes no lockfile and its devDependencies point at unpublished
# workspace packages, so npm ci can't use the tarball as-is. The committed
# lockfile is generated from the tarball's runtime deps only.
# To bump: ./bump-command-code.sh [version]
buildNpmPackage (finalAttrs: {
  pname = "command-code";
  version = "1.88.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/command-code/-/command-code-${finalAttrs.version}.tgz";
    hash = "sha512-8es7pmDlw1YYbUYUW3RHDGyI3zBQAhvkZaBh2ZxSnuuzZY1mavrN4e5+SICi8nBqah6GYThMLtvfqmFnL95i3A==";
  };

  npmDepsHash = "sha256-JW9iifZ4BpCoUawG8gp4Wpr5DbxVUhrPROVfPfrWSZo=";

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    sed -i '/"devDependencies": {/,/^  }/d' package.json
  '';

  dontNpmBuild = true;
  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ libgcc.lib ]; # @crosscopy/clipboard .node

  meta = {
    description = "Coding agent that continuously learns your coding taste";
    homepage = "https://commandcode.ai/docs";
    mainProgram = "cmd";
  };
})
