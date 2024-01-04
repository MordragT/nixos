## Reinstall

- make sure /mnt is owned by root:root and has 755 (otherwise weird /nix/var/nix/profiles 755 operation not permitted error)
- maybe delete old .nix files in /home/user
- maybe make users temporarily immutable
- temporarily comment out packages not served by the default cache