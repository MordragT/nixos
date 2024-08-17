{system}: {
  opencv-typing =
    import (builtins.fetchTarball {
      url = "https://github.com/frc4451/nixpkgs/archive/5add1fa44d485393925d5cb6e3370037866826b2.tar.gz";
      sha256 = "17mpf8va6q5g29mg367ipvr24rv2blm8cmg78r683pijk54ijc1l";
    }) {
      inherit system;
    };
  # setuptools =
  #   import (builtins.fetchTarball {
  #     url = "https://github.com/frc4451/nixpkgs/archive/bbca5dc9905acfb592b436ce353be72bffb1edf0.tar.gz";
  #     sha256 = "";
  #   }) {
  #     inherit system;
  #   };
}
