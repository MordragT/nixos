{...}: {
  services.tailscale.enable = true;
  #programs.haguichi.enable = true;
  #services.logmein-hamachi.enable = true;

  # Strict reverse path filtering breaks Tailscale exit node use and some subnet routing setups.
  networking.firewall.checkReversePath = "loose";
}
