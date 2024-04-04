{pkgs, ...}: {
  security.acme.defaults.email = "contact.mordrag+acme@gmail.de";
  security.acme.acceptTerms = true;

  security.pam.mount.additionalSearchPaths = [pkgs.bindfs];

  environment.etc = {
    # CK3 fix
    "ssl/certs/f387163d.0".source = "${pkgs.cacert.unbundled}/etc/ssl/certs/Starfield_Class_2_CA.crt";
  };

  # Crusader Kings
  networking.firewall.allowedTCPPorts = [27015 27036];
  networking.firewall.allowedUDPPorts = [27015 27031 27032 27033 27034 27036 27036];

  # recommended for pipewire
  security.rtkit.enable = true;

  # for sway
  security.polkit.enable = true;
}
