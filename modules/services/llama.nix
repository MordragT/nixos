{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mordrag.services.llama;
in {
  options.mordrag.services.llama = {
    enable = lib.mkEnableOption "Llama";
  };

  config = lib.mkIf cfg.enable {
    services.llama-cpp = {
      enable = true;
      package = pkgs.llama-cpp.override {
        vulkanSupport = true;
      };
      port = 8030;
      model = "/var/lib/llama-cpp/Meta-Llama-3-8B-Instruct-Q4_K_M.gguf";
    };

    services.open-webui = {
      enable = true;
      port = 8040;
      openFirewall = false;
      environment = {
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
        OPENAI_API_BASE_URL = "http://127.0.0.1:8030/v1/";
        TRANSFORMERS_CACHE = "/var/lib/open-webui/.cache/huggingface";
      };
    };

    # systemd.services.llama-cpp = {
    #   description = "LLaMA C++ server";
    #   after = ["network.target"];
    #   wantedBy = ["multi-user.target"];

    #   serviceConfig = {
    #     Type = "idle";
    #     KillSignal = "SIGINT";
    #     ExecStart = "${pkgs.llama-cpp-sycl}/bin/llama-server --log-disable --host 127.0.0.1 --port 8030 -m /var/lib/llama-cpp/llama-2-7b.Q4_K_M.gguf";
    #     Restart = "on-failure";
    #     RestartSec = 300;

    #     # for GPU acceleration
    #     PrivateDevices = false;

    #     # hardening
    #     DynamicUser = true;
    #     CapabilityBoundingSet = "";
    #     RestrictAddressFamilies = [
    #       "AF_INET"
    #       "AF_INET6"
    #       "AF_UNIX"
    #     ];
    #     NoNewPrivileges = true;
    #     PrivateMounts = true;
    #     PrivateTmp = true;
    #     PrivateUsers = true;
    #     ProtectClock = true;
    #     ProtectControlGroups = true;
    #     ProtectHome = true;
    #     ProtectKernelLogs = true;
    #     ProtectKernelModules = true;
    #     ProtectKernelTunables = true;
    #     ProtectSystem = "strict";
    #     MemoryDenyWriteExecute = false; # this is changed to allow textrels inside oneapi shared objects to work
    #     LockPersonality = true;
    #     RemoveIPC = true;
    #     RestrictNamespaces = true;
    #     RestrictRealtime = true;
    #     RestrictSUIDSGID = true;
    #     SystemCallArchitectures = "native";
    #     SystemCallFilter = [
    #       "@system-service"
    #       "~@privileged"
    #     ];
    #     SystemCallErrorNumber = "EPERM";
    #     ProtectProc = "invisible";
    #     ProtectHostname = true;
    #     ProcSubset = "pid";
    #   };
    # };
  };
}
