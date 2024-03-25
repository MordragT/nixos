{system}: {
  vpl =
    import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/88add7e28ef9e6610619bac4752a11be0830a0d2.tar.gz";
      sha256 = "1f5kckzrnm523sgcspviwj1a3fyl0i3px9xgap84nzwpz2k34ars";
    }) {
      inherit system;
    };
}
