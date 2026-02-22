{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.mordrag.services.step-ca;
in
{
  options.mordrag.services.step-ca = {
    enable = lib.mkEnableOption "Step CA";
    fqdn = lib.mkOption {
      description = "Domain";
      default = "ca.local";
      type = lib.types.nonEmptyStr;
    };
  };

  config = {
    # Install certificates by default in every machine
    security.pki.certificateFiles = [
      ./root-ca.crt
      ./intermediate-ca.crt
    ];
  }
  // lib.mkIf cfg.enable {
    vaultix.secrets = {
      step-ca = {
        file = ./step-ca.age;
        owner = config.users.users.step-ca.name;
        group = config.users.groups.step-ca.name;
      };
      intermediate-ca = {
        file = ./intermediate-ca.age;
        owner = config.users.users.step-ca.name;
        group = config.users.groups.step-ca.name;
      };
    };

    environment.systemPackages = [
      pkgs.step-cli # generate certificates
    ];

    services = {
      step-ca = {
        enable = true;
        intermediatePasswordFile = config.vaultix.secrets.step-ca.path;
        address = "0.0.0.0";
        port = 8443;
        openFirewall = true;
        settings = {
          root = ./root-ca.crt;
          federatedRoots = null;
          crt = ./intermediate-ca.crt;
          key = config.vaultix.secrets.intermediate-ca.path;
          dnsNames = [
            cfg.fqdn
            "localhost"
          ];
          logger = {
            format = "text";
          };
          db = {
            type = "badgerv2";
            dataSource = "/var/lib/step-ca/db";
          };
          authority = {
            provisioners = [
              {
                type = "ACME";
                name = "acme";
                forceCN = true;
              }
              {
                type = "JWK";
                name = "connect.mordrag@gmx.de";
                key = {
                  "use" = "sig";
                  "kty" = "EC";
                  "kid" = "h2lKD4JCVh1TaPagda844dt_mC6OEkL9axJHf95c72A";
                  "crv" = "P-256";
                  "alg" = "ES256";
                  "x" = "sYIzsLF4tDHV0ZNvCyKGF_NwyWrMSBSCbhK4yaj2fPM";
                  "y" = "scT_nhZUWGP1H_m3RAc4QE4xKjXTYyUZsbHy1eEOG9E";
                };
                encryptedKey = "eyJhbGciOiJQQkVTMi1IUzI1NitBMTI4S1ciLCJjdHkiOiJqd2sranNvbiIsImVuYyI6IkEyNTZHQ00iLCJwMmMiOjYwMDAwMCwicDJzIjoiMGlmM0dkVHViX3JhSzB6Z1RaRks2ZyJ9.3j4WO15pobxxZwjup7cissROvM1aj25EAwTbZdfpkiXkMEjF2EpL5Q.bFFsZmxRzqtEtAxx.IC29CNed0MulVEZXQYtnbjc0J_NcQZgSusL9uTP4U08z15c9iDZVN4707unHgmjJJjHgoH_hBV24ifmgR5s9dkpeZx3-0ZsEuXyZtW2ZV-oRsbNl8m8O2ev9tyJgSX08exjaiflo6LMSDbv1ot_0f1Qvb_rGkuJbDNozp3dWFEQXiGGTiDfemM6Q9ULVBnZz0I_xcG2RBOFdWJxXpTPrj0a7DTL6EwnFmYpTkF6Bxp-gzvmt4GqzCnvzJcSyhec1nG8EGil7UyT9IluJcOsY2i7hKCJHJxduppNpoNlU100ngXnFoyL7EGA9YlN58yZi6XM-Bibu9ZVNEMdPV4Q.O8VES0IMWtH40aLdr83SYg";
              }
            ];
          };
          tls = {
            cipherSuites = [
              "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256"
              "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"
            ];
            minVersion = 1.2;
            maxVersion = 1.3;
            renegotiation = false;
          };
        };
      };

      valhali = {
        enable = true;
        services = {
          step-ca = {
            alias = cfg.fqdn;
            port = 8443;
            kind = "https";
          };
        };
      };
    };
  };
}
