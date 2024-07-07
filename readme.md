
<div align=center>

# ❄️ Nixos Config

 [![NixOS](https://img.shields.io/badge/Flakes-Nix-informational.svg?logo=nixos&style=for-the-badge)](https://nixos.org) ![License](https://img.shields.io/github/license/mordragt/nixos?style=for-the-badge)

System and home-manager configuration for my linux machines.

</div>

## 📦 Contents

- `config/`: Nixos configuration
- `home/`: Home-Manager configuration
- `hosts/`: Machine specific configurations
- `modules/`: Nixos modules
- `pkgs/`: Overlays for various packages
- `scripts/`: Nushell scripts for inclusion into my configs
- `secrets/`: Encrypted secrets used by some services

## 🚀 How to use ?

You probably want to use flakes to use the overlay and modules defined in this repo.

TODO: Show some basic examples on how to use the overlay/modules

### Install on new system

1. Create partitions as per your requirements (e.g., using disko or parted).
2. Mount the partitions, excluding any tmpfs partitions.
3. Comment out the machine-id under impermanence.
4. Run the nixos-install command.
5. Copy the machine-id and other necessary files into the persisted directories.
6. Uncomment the machine-id.
7. Run the nixos-install command again.


```bash
nix-shell -p git
sudo nixos-install --flake uri#system
```

## ✨ Features

### 🤫 Impermanence

Instead of tediously specifying all the files you want to keep, the `environment.state` module allows you to specify only the folders you want to overlay by symlink or by mount.
Say you have folders under `/nix/state/users/name/data` where you have all the folders which sadly do not follow the XDG directories like `.ssh` or `.minecraft` and you have
your home folders like `Desktop` or `Documents` under `/nix/state/users/name/home`. Then you can specify the following config:

```nix
# config/impermanence.nix
environment.state = {
    enable = true;
    targets = [
        {
            source = "/nix/state/users/name/home";
            destination = "/home/name";
            method = "mount";
            owner = "name";
            group = "users";
            mode = "0700";
        }
        {
            source = "/nix/state/users/name/data";
            destination = "/home/name";
            method = "mount";
            owner = "name";
            group = "users";
            mode = "0700";
        }
    ];
}
```

Now to include the right folders you can just put an **@** behind every folder you want to overlay into the destination.
For example your folder structure might look like the following:

```
/nix/state/users/name/home
    - Desktop@
    - Documents@
        - important_stuff
        - inner_folder
    - some_other_folder
```

Now `Desktop@` and `Documents@` will be mounted/symlinked at startup to your home folders `Desktop` and `Documents`

### 🦊 Firefox Addons

Under `pkgs/firefox-addons` are a bunch of firefox addons defined. But instead of manually creating derivations for each addon,
the addons are generated via the `pkgs/firefox-addons/mod.nu` nushell script. The resulting `addons.json` is then used to create
the respective derivations.

Now to add addons you can just add the slugs into the `pkgs/firefox-addons/mod.nu` script and recreate the `addons.json` file
by first deleting it and then running the `just create-firefox` command from the root of the repository.
When you want to update the addons just run `just update-firefox`

*Disclaimer*: Due to some limitations of nushell, at the moment the path of `addons.json` is hardcoded into `pkgs/firefox-addons/mod.nu`.
    You ~~might~~ probably want to change that

### 💻 Vscode Extensions

The vscode extensions are very similar to the firefox addons and are defined under `pkgs/vscode-extensions`.
The **disclaimer** also applies!

### 🚧 WIP Intel OneAPI

In an effort to make the *Intel Extension for Pytorch* work, I created a multitude of packages.
Under `pkgs/intel-packages` are lying the intel oneapi packages like *dpcpp* or *mkl* with the exception of the python specific
packages wich are under `pkgs/python-packages`.
The open source packages of the oneapi are defined under `pkgs/oneapi-packages` and the open source *intel llvm* project is currently in `pkgs/xpu-packages`.

To use the dpcpp compiler you may want to use `intelPackages.env.mkDerivation`, which is currently somewhat functional.
The python packages are sadly not functional at the moment.

### 🍷 Wine Bottles

With the constructs defined under `pkgs/win-packages` you can create wine bottles for your windows programs.
Here is an example for battle.net:

```nix
# pkgs/win-packages/battle-net.nix
{
  mkBottle,
  wineWowPackages,
}:
mkBottle {
  wine = wineWowPackages.waylandFull;
  wineArch = 64;

  name = "battle-net";

  packages = [
    "dxvk"
    "tahoma"
    "arial"
  ];

  registry = [
    {
      path = ''HKCU\Software\Wine\Drivers'';
      key = "Graphics";
      type = "REG_SZ";
      value = "wayland";
    }
    {
      path = ''HKCU\Software\Wine'';
      key = "Version";
      type = "REG_SZ";
      value = "win10";
    }
    {
      path = ''HKCU\Software\Wine\AppDefaults\BlizzardBrowser.exe'';
      key = "version";
      type = "REG_SZ";
      value = "win7";
    }
    {
      path = ''HKCU\Software\Wine\DXVA2'';
      key = "backend";
      type = "REG_SZ";
      value = "va";
    }
  ];

  workingDir = "drive_c/Program Files (x86)/Battle.net/";
  exe = "Battle.net.exe";
}
```

This will create a program `battle-net`:

```bash
battle-net run # by default executed if 'run' not specified
battle-net setup <exe>
```

### 🛑 Other packages

There exist some packages in this repository which are not functional at the moment. I still keep them in here as documentation for future packaging efforts.
I try to mark them as broken but I might have forgotten some. If you encounter any broken packages please create an issue.

## ❔ FAQ

... Waiting for questions ... (raise an issue in case of doubts)

## ❤️ Support

Consider starring the repo ⭐❄️
