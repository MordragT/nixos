{ pkgs, config, lib, ... }:
{
  services.step-ca = {
    enable = true;
    address = "127.0.0.1";
    port = 8443;    
    intermediatePasswordFile = ./secrets/step-ca/password;
    settings = {
      root = "./secrets/step-ca/root_ca.crt";
      crt = "./secrets/step-ca/intermediate_ca.crt";
      key = "./secrets/step-ca/intermediate_ca_key";
      dnsNames = [ "localhost" ];
      logger.format = "text";
      db = {
        type = "badgerV2";
        dataSource = "/var/lib/step-ca/db";    
      };
      authority.provisioners = [
        {
          type = "ACME";
          name = "acme";    
          
        }  
      ];
    };
  };
    
  security.acme.server = "https://localhost:8443/acme/acme/directory";  
  security.pki.certificateFiles = [
    "./secrets/step-ca/root_ca.crt"
    "./secrets/step-ca/intermediate_ca.crt"    
  ];
    
  users.users.step-ca = {
    group = "step-ca";
    extraGroups = [ "secrets" ];
    isSystemUser = true;    
  };
  users.groups.step-ca = { };
  users.groups.secrets.name = "secrets";
    
  systemd.tmpfiles.rules = [
    "d ./secrets 750 root secrets"    
    "z ./secrets 750 root secrets"
    "d /var/lib/step-ca 700 step-ca step-ca"    
    "z /var/lib/step-ca 700 step-ca step-ca"    
    "d /var/log/caddy 750 caddy caddy"
    "z /var/log/caddy 750 caddy caddy"
  ];
          
  systemd.services."step-ca" = {
    serviceConfig = {
      WorkingDirectory = lib.mkForce "/var/lib/step-ca";
      Environment = lib.mkForce "Home=/var/lib/step-ca";
      User = "step-ca";
      Group = "step-ca";
      DynamicUser = lib.mkForce false;
      # SystemCallArchitectures = "native";
      # SystemCallFilter = [
      #   "@system-service"
      #   "~@privileged"
      #   "~@chown"
      #   "~@aio"
      #   "~@resources"
      # ];    
    };    
  };
}
