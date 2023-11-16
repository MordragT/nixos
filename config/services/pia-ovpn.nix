{
  pkgs,
  config,
  ...
}: let
  makeServer = file: {
    name = builtins.replaceStrings [".ovpn" "_"] ["" "-"] file;
    value = {
      autoStart = false;
      authUserPass.username = "p9971552";
      # TODO not working as it is read as string
      # wait for https://github.com/NixOS/nixpkgs/pull/239268
      authUserPass.password = "${config.classified.targetDir}/pia";
      config = "config ${pkgs.pia-openvpn}/${file}";
      updateResolvConf = true;
    };
  };
  servers = with builtins; listToAttrs (map makeServer (attrNames (readDir "${pkgs.pia-openvpn}/")));
in {
  classified.files.pia.encrypted = ../../secrets/pia/pia.enc;

  services.openvpn.servers = servers;
}
