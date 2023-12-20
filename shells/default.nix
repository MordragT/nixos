{pkgs}: {
  default = pkgs.mkShell {
    buildInputs = [];
  };
  stable-diffusion-webui = import ./stable-diffusion-webui.nix {inherit pkgs;};
}
