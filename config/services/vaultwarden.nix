{...}: {
  services.vaultwarden = {
    enable = true;
    config = {
      domain = "https://bitwarden.localhost";
      rocketPort = 3030;
    };
  };

  services.caddy.virtualHosts."bitwarden.localhost" = {
    extraConfig = ''
      tls connect.mordrag@gmx.de {
        ca https://localhost:8443/acme/acme/directory
      }
      reverse_proxy http://localhost:3030
    '';
  };
}
