{
  stdenv,
  lib,
  fetchurl,
  dpkg,
}:
stdenv.mkDerivation {
  pname = "webdesigner";
  version = "14.0.4";

  src = fetchurl {
    url = "https://dl.google.com/linux/direct/google-webdesigner_current_amd64.deb";
    sha256 = "hLr3E8BaYV7h5PJIEPmSJVht+WuJuxWXSZH0cG1h2cw=";
  };

  nativeBuildInputs = [dpkg];
  buildInputs = [];

  dontBuild = true;

  unpackPhase = ''
    dpkg-deb -R $src .
  '';

  installPhase = ''
    runHook preInstall
    cp -r opt $out/
    ln -s $out/bin/webdesigner $out/usr/bin/webdesigner
    ln -s $out/share/google-webdesigner.desktop $out/usr/share/google-webdesigner.desktop
    runHook postInstall
  '';

  meta = with lib; {
    license = licenses.unfree;
    maintainers = with maintainers; [mordrag];
    description = "Google Web Designer for Linux";
    platforms = platforms.linux;
    broken = true;
  };
}
