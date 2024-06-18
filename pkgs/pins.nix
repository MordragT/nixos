{system}: {
  # vpl =
  #   import (builtins.fetchTarball {
  #     url = "https://github.com/NixOS/nixpkgs/archive/88add7e28ef9e6610619bac4752a11be0830a0d2.tar.gz";
  #     sha256 = "1f5kckzrnm523sgcspviwj1a3fyl0i3px9xgap84nzwpz2k34ars";
  #   }) {
  #     inherit system;
  #   };

  opencv-typing =
    import (builtins.fetchTarball {
      url = "https://github.com/frc4451/nixpkgs/archive/5add1fa44d485393925d5cb6e3370037866826b2.tar.gz";
      sha256 = "17mpf8va6q5g29mg367ipvr24rv2blm8cmg78r683pijk54ijc1l";
    }) {
      inherit system;
    };
}
