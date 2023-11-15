{...}: {
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  services.samba.enable = true;
  services.samba.openFirewall = true;
}
