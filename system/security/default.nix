{ ... }:
{
  security.acme.defaults.email = "connect.mordrag@gmx.de";
  security.acme.acceptTerms = true;
  security.pki.certificateFiles = [ ../../secrets/Starfield_Class_2_CA.crt ];
  # recommended for pipewire
  security.rtkit.enable = true;
}
