{pkgs, ...}: {
  imports = [
    ../base
  ];

  mordrag.programs.git.enable = true;
  mordrag.programs.helix.enable = true;
  mordrag.programs.mangohud.enable = true;
  mordrag.programs.nushell.enable = true;
  mordrag.programs.zed-editor.enable = true;

  programs.chromium.enable = true;

  home.packages = with pkgs; [
    # superTuxKart
    heroic
  ];

  # The steam controller really doesn't like non steam games so just use retroarch of steam itsself

  # home.packages = with pkgs; [
  #   (retroarch.withCores (cores:
  #     with cores; [
  #       # https://github.com/NixOS/nixpkgs/tree/master/pkgs/applications/emulators/libretro/cores
  #       dolphin
  #     ]))
  # ];

  # xdg.dataFile."Steam/userdata/100029185/config/shortcuts.vdf" = let
  #   json2vdf = pkgs.writers.writePython3 "json2vdf.py" {libraries = [pkgs.python3Packages.vdf];} ''
  #     import json
  #     import sys
  #     import vdf

  #     def json2vdf(data):
  #         if isinstance(data, dict):
  #             return {k: json2vdf(v) for k, v in data.items()}
  #         if isinstance(data, list):
  #             return {str(k): json2vdf(v) for k, v in enumerate(data)}
  #         else:
  #             return data

  #     with open(sys.argv[1]) as fp:
  #         data = json.load(fp)

  #     data = json2vdf(data)

  #     with open(sys.argv[2], "wb") as fp:
  #         vdf.binary_dump(data, fp)
  #   '';
  #   generate = name: value: (pkgs.runCommand name {
  #       value = builtins.toJSON value;
  #       passAsFile = ["value"];
  #     } ''
  #       ${json2vdf} "$valuePath" "$out"
  #     '');
  # in {
  #   force = true;
  #   source = generate "shortcuts" {
  #     shortcuts = [
  #       {
  #         # TODO: Compute grid art compatible id
  #         # https://gaming.stackexchange.com/questions/386882/how-do-i-find-the-appid-for-a-non-steam-game-on-steam
  #         AppId = -176156456;
  #         AppName = "RetroArch";
  #         Exe = "retroarch";
  #         AllowOverlay = 1;
  #       }
  #     ];
  #   };
  # };
}
