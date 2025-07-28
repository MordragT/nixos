{...}: {
  specialisation.cosmic.configuration = {
    system.nixos.tags = ["steam"];

    jovian.steam = {
      enable = true;
      autoStart = true;
    };
  };
}
