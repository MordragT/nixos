{...}: {
  services.samba = {
    enable = true;
    openFirewall = true;
    shares = {
      public = {
        path = "/srv/public";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "root";
        "force group" = "root";
      };
    };
  };
}
