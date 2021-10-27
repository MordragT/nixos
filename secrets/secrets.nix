let
  rootLaptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFbYNAgtNKW9W/ytSHQlx4jmiNpeNDA7OEORDNh+Vx3P root@nixos";
  tomLaptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICwAMqV1eL3t0cHnPHwXR2Dj4oDHXR64AX2avGkkkaKW tom@tom-laptop";
  rootDesktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBRTN+C6PFAtIeMvSo7gGXS4baEbjNbEenAaUmiADXtM root@tom-pc";
  tomDesktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIm/oTrV+ISStJ7Gb3ES7lZdCfya2TdEtkFZ/A1rqYEv tom@tom-pc";
  keys = [ rootLaptop tomLaptop rootDesktop tomDesktop ];
in {
  
  "nextcloud.age".publicKeys = keys;  
  "step-ca.age".publicKeys = keys;
}
