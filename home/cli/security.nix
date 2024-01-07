{pkgs, ...}: {
  home.packages = with pkgs; [
    authoscope # scriptable network authentication cracker
    macchanger # change the network's mac address
    rustscan # modern portscanner
    steghide # stenography hiding in files
    step-cli # generate certificates
    sn0int # semi automatic osint framework
  ];
}
