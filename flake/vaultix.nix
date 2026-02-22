{ inputs, self, ... }:
{
  imports = [ inputs.vaultix.flakeModules.default ];

  flake.vaultix = {
    # extraRecipients = [ ];                 # default, optional
    # cache = "./secrets/cache";             # default, optional
    # defaultSecretDirectory = "./secrets";  # default, optional
    # nodes = self.nixosConfigurations;      # default, optional
    # extraPackages = [ ];                   # default, optional
    # pinentryPackage = null;                # default, optional
    nodes = {
      inherit (self.nixosConfigurations) tom-desktop;
    };
    identity = "~/.config/age/keys.txt";
  };
}
