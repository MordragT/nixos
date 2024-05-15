{pkgs, ...}: {
  mordrag.services.comfyui = {
    enable = false;
    # intel arc letzze goo ... soon hopefully
    extraArgs = "--use-pytorch-cross-attention --highvram";
    package = pkgs.comfyui.override {gpuBackend = "xpu";};
  };
  mordrag.services.printing.enable = true;
  mordrag.services.step-ca.enable = true;
  # mordrag.services.forgejo.enable = true;
  mordrag.services.harmonia.enable = true;
  # mordrag.services.vaultwarden.enable = true;

  services.flatpak.enable = true;
  # services.private-gpt.enable = true;
  services.tailscale.enable = true;
  # Strict reverse path filtering breaks Tailscale exit node use and some subnet routing setups.
  networking.firewall.checkReversePath = "loose";

  services.tor.enable = true;
  services.udev.packages = with pkgs; [
    platformio-core
    # openocd # plugdev errors are polluting the logs
  ];
  services.xserver.wacom.enable = true;
}
