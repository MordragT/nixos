{pkgs, ...}: {
  security.acme.defaults.email = "contact.mordrag+acme@gmail.de";
  security.acme.acceptTerms = true;

  security.pam.mount.additionalSearchPaths = [pkgs.bindfs];

  # recommended for pipewire
  security.rtkit.enable = true;

  # for sway
  security.polkit.enable = true;

  security.pki.certificateFiles = [
    ../certs/root_ca.crt
    ../certs/intermediate_ca.crt
  ];
}
