{...}: {
  services.samba = {
    enable = true;
    openFirewall = true;
    shares = {
      public = {
        path = "/srv/public";
        "read only" = false;
        browseable = "yes";
        "guest ok" = "yes";
        comment = "Public samba share.";
      };
    };
  };
}
