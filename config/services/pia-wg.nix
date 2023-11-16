{config, ...}: {
  classified.files.pia-env.encrypted = ../../secrets/pia/pia-env.enc;

  services.pia-wg = {
    enable = true;
    environmentFile = "${config.classified.targetDir}/pia-env";
    certificateFile = ../../secrets/pia/ca.rsa.4096.crt;
  };
}
