let
  rootLaptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFbYNAgtNKW9W/ytSHQlx4jmiNpeNDA7OEORDNh+Vx3P root@nixos";
  tomLaptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICwAMqV1eL3t0cHnPHwXR2Dj4oDHXR64AX2avGkkkaKW tom@tom-laptop";
  keys = [ rootLaptop tomLaptop ];
in {
  
  "nextcloud.age".publicKeys = keys;  
  "step-ca.age".publicKeys = keys;
}
