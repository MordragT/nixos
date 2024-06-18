{
  mkYarnPackage,
  makeWrapper,
  makeDesktopItem,
  fetchFromGitHub,
  ffmpeg,
  electron,
}:
mkYarnPackage rec {
  name = "astrofox";

  src = fetchFromGitHub {
    owner = "astrofox-io";
    repo = "astrofox";
    rev = "a0cc4baf4ff11e47102d7857aebbb5d08cf09558";
    sha256 = "G8rT0yhPN/MdgKi4qPk/Uw4rWTYBLvxc5g7FRq+trjA=";
  };

  buildPhase = ''
    yarn build-prod
  '';

  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    mkdir -p "$out/share/astrofox"
    cp -r ./deps/astrofox "$out/share/astrofox/electron"
    rm "$out/share/astrofox/electron/node_modules"
    cp -r ./node_modules "$out/share/astrofox/electron"

    mkdir -p $out/share/astrofox/electron/deps
    ln -s $out/share/astrofox/electron $out/share/astrofox/electron/deps/astrofox

    mkdir -p $out/libexec/astrofox
    ln -s $out/share/astrofox/electron/deps $out/libexec/astrofox/deps

    mkdir -p $out/share/astrofox/bin
    ln -s "${ffmpeg}/bin/ffmpeg" "$out/share/astrofox/bin/ffmpeg"

    ln -s "${desktopItem}/share/applications" "$out/share/applications"

    makeWrapper "${electron}/bin/electron" "$out/bin/astrofox" \
      --add-flags "$out/share/astrofox/electron"
  '';

  desktopItem = makeDesktopItem {
    name = "astrofox";
    exec = "astrofox";
    desktopName = "Astrofox Audio Visualizer";
    genericName = "Audio Visualizer";
  };

  meta.broken = true;
}
