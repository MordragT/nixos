{
  config,
  pkgs,
  ...
}: {
  #   home.activation.blender = let
  #     link-dir = pkgs.writeScript "link-dir" ''
  #       #! ${pkgs.nushell}/bin/nu

  #       let dir = "${config.home.homeDirectory}/.config/blender"

  #       if not ($dir | path exists) {
  #         ln -s $"/nix/state($dir)" $dir
  #       } else {
  #         touch /home/tom/test
  #       }
  #     '';
  #   in {
  #     data = "${link-dir}";
  #     after = ["linkGeneration"];
  #     before = [];
  #   };
}
# if [ ! -d "${config.home.homeDirectory}/.config/blender" ]; then
#   ln -s /state/${config.home.homeDirectory}/.config/blender "${config.home.homeDirectory}/.config/blender"
# fi

