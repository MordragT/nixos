{ pkgs }:
with pkgs; [
  # Rust Tools
  rustscan # modern portscanner
  sn0int # semi automatic osint framework
  authoscope # scriptable network authentication cracker
  metadata-cleaner

  cutter
  ghidra
  macchanger # change the network's mac address
  # tor-browser-bundle-bin
  step-cli # generate certificates
]
