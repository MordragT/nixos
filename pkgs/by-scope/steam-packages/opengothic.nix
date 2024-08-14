{
  mkCompat,
  x86-64-v3Packages,
}:
mkCompat {
  name = "Opengothic";
  run = ''
    gothic_dir=$(dirname $(dirname "$1"))
    ${x86-64-v3Packages.opengothic}/bin/opengothic -g $gothic_dir $@ > /tmp/compat.log 2> /tmp/compat_err.log
  '';
}
