{ pkgs, lib, name, mem, vcpu, rootDisk, socket, shares, interfaces }:

let
  preStart = ''
    # workaround cloud-hypervisor sometimes
    # stumbling over a preexisting socket
    rm -f '${socket}'
  '';
  start = lib.escapeShellArgs (
    [
      "${pkgs.cloud-hypervisor}/bin/cloud-hypervisor"
      "--memory"
      "size=${toString mem}M,mergeable=on,shared=on"
      "--cpus"
      "boot=${toString vcpu}"
      "--watchdog"
      "--console"
      "tty"
      "--kernel"
      "${config.system.build.kernel.dev}/vmlinux"
      "--cmdline"
      "console=hvc0 reboot=t panic=-1 ${toString config.microvm.kernelParams}"
      "--seccomp"
      "true"
      "--disk"
      "path=${rootDisk},readonly=on"
      "--api-socket"
      socket
    ]
    ++
    lib.optionals (shares != [ ]) (
      [ "--fs" ] ++
      map
        ({ socket, tag, ... }:
          "tag=${tag},socket=${socket}"
        )
        shares
    )
    ++
    lib.optionals (interfaces != [ ]) (
      [ "--net" ] ++
      map
        ({ id, mac, ... }:
          "tap=${id},mac=${mac}"
        )
        interfaces
    )
  );
  stop = ''
    ${pkgs.curl}/bin/curl \
      --unix-socket ${socket} \
      -X PUT http://localhost/api/v1/vm.power-button \

    # wait for exit
    && ${pkgs.socat}/bin/socat STDOUT UNIX:${socket},shut-none
  '';
  user = "cloud-hypervisor";
  group = "cloud-hypervisor";
in
{
  users.users.${user} = {
    inherit group;
  };

  systemd.services."cloud-hypervisor-virtiofsd@${name}" = {
    description = "VirtioFS daemons for Cloud Hypervisor VM ${name}";
    before = [ "cloud-hypervisor@${name}" ];
    after = [ "local-fs.target" ];
    partOf = [ "cloud-hypervisor@${name}" ];
    serviceConfig = {
      Type = "forking";
      Restart = "always";
    };
    script = lib.foldl (a: b: a + "\n" + b) "" (lib.optionals (shares != [ ]) (
      map
        ({ socket, source, ... }:
          ''
            ${pkgs.virtiofsd}/bin/virtiofsd \
              --socket-path=${socket} \
              --socket-group=${group} \
              --shared-dir ${source} &
            # detach from shell, but remain in systemd cgroup
            disown
          ''
        )
        shares
    ));
  };

  systemd.services."cloud-hypervisor@${name}" = {
    inherit preStart;
    description = "Cloud Hypervisor VM ${name}";
    requires = [ "cloud-hypervisor-virtiofsd@${name}" ];
    # start after boot
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      User = user;
      Group = group;
      ExecStart = start;
      ExecStop = stop;
    };
  };
}


