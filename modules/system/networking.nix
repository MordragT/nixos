{...}: {
  networking = {
    useDHCP = true;
    useNetworkd = true;

    extraHosts = ''
      127.0.0.1 mordrag.io
    '';
  };
}
