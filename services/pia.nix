{ pkgs, lib, config, ... }:
let
    secrets = config.age.secrets;
    secret = path: {
        file = path;
        owner = "root";
        group = "root";
        mode = "0440";
    };

    interface = "wg0";
    certificate = ../secrets/pia/ca.rsa.4096.crt;
    maxLatency = 0.5;
    portForward = false;
    portForwardScript = "";
in {
    age.secrets.pia = secret ../secrets/pia.age;

    systemd.services.pia-vpn = {
      # enable = false;
      description = "Connect to Private Internet Access on ${interface}";
      path = with pkgs; [ bash curl gawk jq wireguard-tools ];
      requires = [ "network-online.target" ];
      after = [ "network.target" "network-online.target" ];
      # wantedBy = [ "multi-user.target" ];

      unitConfig = {
        ConditionFileNotEmpty = [
          certificate
          secrets.pia.path
        ];
      };

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        Restart = "on-failure";
        RestartSec = "1s";
        EnvironmentFile = secrets.pia.path;

        CacheDirectory = "pia-vpn";
        StateDirectory = "pia-vpn";
      };

      script = ''
        printServerLatency() {
          serverIP="$1"
          regionID="$2"
          regionName="$(echo ''${@:3} |
            sed 's/ false//' | sed 's/true/(geo)/')"
          time=$(LC_NUMERIC=en_US.utf8 curl -o /dev/null -s \
            --connect-timeout ${toString maxLatency} \
            --write-out "%{time_connect}" \
            http://$serverIP:443)
          if [ $? -eq 0 ]; then
            >&2 echo Got latency ''${time}s for region: $regionName
            echo $time $regionID $serverIP
          fi
        }
        export -f printServerLatency
        echo Determining region...
        serverlist='https://serverlist.piaservers.net/vpninfo/servers/v4'
        allregions=$(curl -s "$serverlist" | head -1)
        filtered="$(echo $allregions | jq -r '.regions[]
                   ${lib.optionalString portForward "| select(.port_forward==true)"}
                   | .servers.meta[0].ip+" "+.id+" "+.name+" "+(.geo|tostring)')"
        best="$(echo "$filtered" | xargs -I{} bash -c 'printServerLatency {}' |
                sort | head -1 | awk '{ print $2 }')"
        if [ -z "$best" ]; then
          >&2 echo "No region found with latency under ${toString maxLatency} s. Stopping."
          exit 1
        fi
        region="$(echo $allregions |
                  jq --arg REGION_ID "$best" -r '.regions[] | select(.id==$REGION_ID)')"
        meta_ip="$(echo $region | jq -r '.servers.meta[0].ip')"
        meta_hostname="$(echo $region | jq -r '.servers.meta[0].cn')"
        wg_ip="$(echo $region | jq -r '.servers.wg[0].ip')"
        wg_hostname="$(echo $region | jq -r '.servers.wg[0].cn')"
        echo "$region" > $STATE_DIRECTORY/region.json
        echo Generating token...
        tokenResponse="$(curl -s -u "$PIA_USER:$PIA_PASS" \
          --connect-to "$meta_hostname::$meta_ip" \
          --cacert "${certificate}" \
          "https://$meta_hostname/authv3/generateToken")"
        if [ "$(echo "$tokenResponse" | jq -r '.status')" != "OK" ]; then
          >&2 echo "Failed to generate token. Stopping."
          exit 1
        fi
        echo "$tokenResponse" > $STATE_DIRECTORY/token.json
        token="$(echo "$tokenResponse" | jq -r '.token')"
        echo Connecting to the PIA WireGuard API on $wg_ip...
        privateKey="$(wg genkey)"
        publicKey="$(echo "$privateKey" | wg pubkey)"
        json="$(curl -s -G \
          --connect-to "$wg_hostname::$wg_ip:" \
          --cacert "${certificate}" \
          --data-urlencode "pt=''${token}" \
          --data-urlencode "pubkey=$publicKey" \
          "https://''${wg_hostname}:1337/addKey")"
        status="$(echo "$json" | jq -r '.status')"
        if [ "$status" != "OK" ]; then
          >&2 echo "Server did not return OK. Stopping."
          >&2 echo "$json"
          exit 1
        fi
        echo Creating network interface ${interface}.
        echo "$json" > $STATE_DIRECTORY/wireguard.json
        gateway="$(echo "$json" | jq -r '.server_ip')"
        servervip="$(echo "$json" | jq -r '.server_vip')"
        peerip=$(echo "$json" | jq -r '.peer_ip')
        mkdir -p /run/systemd/network/
        touch /run/systemd/network/60-${interface}.{netdev,network}
        chown root:systemd-network /run/systemd/network/60-${interface}.{netdev,network}
        chmod 640 /run/systemd/network/60-${interface}.{netdev,network}
        cat > /run/systemd/network/60-${interface}.netdev <<EOF
        [NetDev]
        Description = WireGuard PIA network device
        Name = ${interface}
        Kind = wireguard
        [WireGuard]
        PrivateKey = $privateKey
        [WireGuardPeer]
        PublicKey = $(echo "$json" | jq -r '.server_key')
        AllowedIPs = 0.0.0.0/0, ::/0
        Endpoint = ''${wg_ip}:$(echo "$json" | jq -r '.server_port')
        PersistentKeepalive = 25
        EOF
        cat > /run/systemd/network/60-${interface}.network <<EOF
        [Match]
        Name = ${interface}
        [Network]
        Description = WireGuard PIA network interface
        Address = ''${peerip}/32
        DNS = 8.8.4.4
        DNS = 8.8.8.8
        IPForward = ipv4
        [RoutingPolicyRule]
        From = ''${peerip}
        Table = 42
        EOF
        echo Bringing up network interface ${interface}.
        networkctl reload
        networkctl up ${interface}
        ${pkgs.systemd}/lib/systemd/systemd-networkd-wait-online -i ${interface}
        ${pkgs.iproute}/bin/ip route add default dev ${interface} table 42
      '';

      preStop = ''
        echo Removing network interface ${interface}.
        rm /run/systemd/network/60-${interface}.{netdev,network} || true
        echo Bringing down network interface ${interface}.
        networkctl down ${interface}
        networkctl reload
      '';
    };

    systemd.services.pia-vpn-portforward = lib.mkIf portForward {
      description = "Configure port-forwarding for PIA connection ${interface}";
      path = with pkgs; [ curl jq ];
      after = [ "pia-vpn.service" ];
      bindsTo = [ "pia-vpn.service" ];
      wantedBy = [ "pia-vpn.service" ];

      serviceConfig = {
        Type = "notify";
        Restart = "always";
        CacheDirectory = "pia-vpn";
        StateDirectory = "pia-vpn";
      };

      script = ''
        if [ ! -f $STATE_DIRECTORY/region.json ]; then
          >&2 echo "Region information not found; is pia-vpn.service running?"
          exit 1
        fi
        wg_hostname="$(cat $STATE_DIRECTORY/region.json | jq -r '.servers.wg[0].cn')"
        if [ ! -f $STATE_DIRECTORY/wireguard.json ]; then
          >&2 echo "Connection information not found; is pia-vpn.service running?"
          exit 1
        fi
        gateway="$(cat $STATE_DIRECTORY/wireguard.json | jq -r '.server_ip')"
        if [ ! -f $STATE_DIRECTORY/token.json ]; then
          >&2 echo "Token not found; is pia-vpn.esrvice running?"
        fi
        token="$(cat $STATE_DIRECTORY/token.json | jq -r '.token')"
        echo Enabling port forwarding...
        pfconfig=
        cacheFile=$STATE_DIRECTORY/portforward.json
        if [ -f "$cacheFile" ]; then
          pfconfig=$(cat "$cacheFile")
          if [ "$(echo "pfconfig" | jq -r '.status')" != "OK" ]; then
            echo "Invalid cached port-forwarding configuration. Fetching new configuration."
            pfconfig=
          fi
        fi
        if [ -z "$pfconfig" ]; then
          echo "Fetching port forwarding configuration..."
          pfconfig="$(curl -s -m 5 \
            --interface ${interface} \
            --connect-to "$wg_hostname::$gateway:" \
            --cacert "${certificate}" \
            -G --data-urlencode "token=''${token}" \
            "https://''${wg_hostname}:19999/getSignature")"
          if [ "$(echo "$pfconfig" | jq -r '.status')" != "OK" ]; then
            >&2 echo "Port forwarding configuration does not contain an OK status. Stopping."
            exit 1
          fi
          echo "$pfconfig" > "$cacheFile"
        fi
        if [ -z "$pfconfig" ]; then
          >&2 echo "Did not obtain port forwarding configuration. Stopping."
          exit 1
        fi
        signature="$(echo "$pfconfig" | jq -r '.signature')"
        payload="$(echo "$pfconfig" | jq -r '.payload')"
        port="$(echo "$payload" | base64 -d | jq -r '.port')"
        expires="$(echo "$payload" | base64 -d | jq -r '.expires_at')"
        echo "Forwarded port $port. Forwarding will expire at $(date --date "$expires")."
        systemd-notify --ready
        sleep 10
        while true; do
          response="$(curl -s -G -m 5 \
            --interface ${interface} \
            --connect-to "$wg_hostname::$gateway:" \
            --cacert "${certificate}" \
            --data-urlencode "payload=''${payload}" \
            --data-urlencode "signature=''${signature}" \
            "https://''${wg_hostname}:19999/bindPort")"
          if [ "$(echo "$response" | jq -r '.status')" != "OK" ]; then
            >&2 echo "Failed to bind port. Stopping."
            exit 1
          fi
          echo "Bound port $port. Forwarding will expire at $(date --date="$expires")."
          ${portForwardScript}
          sleep 900
        done
      '';
    };
}