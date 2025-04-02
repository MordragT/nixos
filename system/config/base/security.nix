{...}: {
  security.sudo-rs.enable = true;
  security.sudo.enable = false;

  security.acme.defaults.email = "contact.mordrag+acme@gmail.de";
  security.acme.acceptTerms = true;
}
