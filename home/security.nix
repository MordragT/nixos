{ pkgs }:
with pkgs; [
  # Rust Tools
  rustscan # modern portscanner
  sn0int # semi automatic osint framework
  authoscope # scriptable network authentication cracker
  metadata-cleaner

  (rizin.withPlugins (p: [
    p.rz-ghidra
    p.jsdec
  ]))
  (cutter.override { rizin = rizin; })
  ghidra
  macchanger # change the network's mac address
  # tor-browser-bundle-bin
  step-cli # generate certificates
]
