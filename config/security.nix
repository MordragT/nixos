{pkgs, ...}: {
  security.acme.defaults.email = "contact.mordrag+acme@gmail.de";
  security.acme.acceptTerms = true;

  security.pam.mount.additionalSearchPaths = [pkgs.bindfs];

  security.pki.certificateFiles = [../secrets/crt/Starfield_Class_2_CA.crt];
  # recommended for pipewire
  security.rtkit.enable = true;
}
