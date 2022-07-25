{ pkgs, config, lib, ... }:
let
  root = ../secrets/step-ca/root_ca.crt;
  crt = ../secrets/step-ca/intermediate_ca.crt;
  key = ../secrets/step-ca/intermediate_ca_key;
in
{
  age.secrets.step-ca = {
    file = ../secrets/step-ca.age;
    owner = "step-ca";
    group = "step-ca";
    mode = "0440";
  };

  services.step-ca = {
    enable = true;
    address = "127.0.0.1";
    port = 8443;
    intermediatePasswordFile = config.age.secrets.step-ca.path;
    settings = {
      inherit root crt key;
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

  security.acme.defaults.server = "https://localhost:8443/acme/acme/directory";
  security.pki.certificateFiles = [
    root
    crt
  ];

  users.users.step-ca = {
    group = "step-ca";
    isSystemUser = true;
  };
  users.groups.step-ca = { };

  systemd.tmpfiles.rules = [
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
