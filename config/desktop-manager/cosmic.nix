{master, ...}: {
  environment.systemPackages = with master; [
    cosmic-icons
    cosmic-settings
    cosmic-comp
    cosmic-panel
    cosmic-applets
    cosmic-edit
    cosmic-greeter
  ];
}
